/**
 * Backend de OAuth para Smart Bitrix24
 * - Troca "authorization code" por access_token/refresh_token com Bitrix24
 * - Endpoint de refresh de token
 * - Segurança: CORS restrito, Helmet, rate limit
 * - NÃO armazenar Client Secret no app móvel. Configure CLIENT_ID e CLIENT_SECRET aqui (.env).
 *
 * Copyright (c) Maximo Tecnologia 2025
 */

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import axios from 'axios';
import { RateLimiterMemory } from 'rate-limiter-flexible';
import pino from 'pino';

dotenv.config();
const logger = pino();

const app = express();
app.use(express.json());
app.use(helmet({
  contentSecurityPolicy: false,
}));
app.use(cors({
  origin: process.env.CORS_ORIGIN?.split(',') ?? ['http://localhost:3000', 'http://localhost:8080'],
  credentials: false,
}));

const limiter = new RateLimiterMemory({
  points: 10, // 10 requisições
  duration: 1, // por segundo
});

app.use(async (req, res, next) => {
  try {
    await limiter.consume(req.ip);
    next();
  } catch {
    res.status(429).json({ error: 'Too Many Requests' });
  }
});

const PORT = process.env.PORT || 3000;
const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;

if (!CLIENT_ID || !CLIENT_SECRET) {
  logger.warn('CLIENT_ID/CLIENT_SECRET não configurados no .env');
}

// Troca code -> tokens
app.post('/oauth/exchange', async (req, res) => {
  try {
    const { code, redirectUri, portalDomain } = req.body || {};
    if (!code || !redirectUri || !portalDomain) {
      return res.status(400).json({ error: 'Parâmetros inválidos' });
    }

    const tokenUrl = `https://${portalDomain}/oauth/token/`;

    const params = new URLSearchParams({
      grant_type: 'authorization_code',
      client_id: CLIENT_ID!,
      client_secret: CLIENT_SECRET!,
      redirect_uri: redirectUri,
      code,
    });

    const { data } = await axios.post(tokenUrl, params, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    });

    // Retorna tokens ao app
    res.json({
      access_token: data.access_token,
      refresh_token: data.refresh_token,
      user_id: data.user_id,
      expires_in: data.expires_in,
    });
  } catch (e: any) {
    logger.error(e?.response?.data || e.message);
    res.status(500).json({ error: 'Falha na troca de token', details: e?.response?.data || e.message });
  }
});

// Refresh token
app.post('/oauth/refresh', async (req, res) => {
  try {
    const { refreshToken, portalDomain } = req.body || {};
    if (!refreshToken || !portalDomain) {
      return res.status(400).json({ error: 'Parâmetros inválidos' });
    }

    const tokenUrl = `https://${portalDomain}/oauth/token/`;

    const params = new URLSearchParams({
      grant_type: 'refresh_token',
      client_id: CLIENT_ID!,
      client_secret: CLIENT_SECRET!,
      refresh_token: refreshToken,
    });

    const { data } = await axios.post(tokenUrl, params, {
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    });

    res.json({
      access_token: data.access_token,
      refresh_token: data.refresh_token,
      expires_in: data.expires_in,
    });
  } catch (e: any) {
    logger.error(e?.response?.data || e.message);
    res.status(500).json({ error: 'Falha no refresh de token', details: e?.response?.data || e.message });
  }
});

app.get('/health', (_, res) => res.json({ ok: true, name: 'smart-bitrix24-backend', version: '1.0.0' }));

app.listen(PORT, () => {
  logger.info(`OAuth backend rodando em http://localhost:${PORT}`);
});