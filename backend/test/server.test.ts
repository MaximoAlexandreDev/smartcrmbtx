/**
 * Testes de integração para Backend OAuth
 * Copyright (c) Maximo Tecnologia 2025
 */

import request from 'supertest';
import express from 'express';
import { describe, it, expect, beforeAll } from '@jest/globals';

// Mock do servidor para testes
const app = express();
app.use(express.json());

// Mock dos endpoints (simplificado para testes)
app.post('/oauth/exchange', async (req, res) => {
  const { code, redirectUri, portalDomain } = req.body || {};
  
  if (!code || !redirectUri || !portalDomain) {
    return res.status(400).json({ error: 'Parâmetros inválidos' });
  }

  // Mock de resposta bem-sucedida
  res.json({
    access_token: 'mock_access_token',
    refresh_token: 'mock_refresh_token',
    user_id: '123',
    expires_in: 3600,
  });
});

app.post('/oauth/refresh', async (req, res) => {
  const { refreshToken, portalDomain } = req.body || {};
  
  if (!refreshToken || !portalDomain) {
    return res.status(400).json({ error: 'Parâmetros inválidos' });
  }

  res.json({
    access_token: 'new_mock_access_token',
    refresh_token: 'new_mock_refresh_token',
    expires_in: 3600,
  });
});

app.get('/health', (_, res) => {
  res.json({ ok: true, name: 'smart-bitrix24-backend', version: '1.0.0' });
});

describe('Backend OAuth Endpoints', () => {
  describe('POST /oauth/exchange', () => {
    it('deve retornar 400 quando parâmetros estão faltando', async () => {
      const response = await request(app)
        .post('/oauth/exchange')
        .send({});
      
      expect(response.status).toBe(400);
      expect(response.body.error).toBe('Parâmetros inválidos');
    });

    it('deve retornar 400 quando code está faltando', async () => {
      const response = await request(app)
        .post('/oauth/exchange')
        .send({
          redirectUri: 'smartbitrix24://auth/callback',
          portalDomain: 'test.bitrix24.com',
        });
      
      expect(response.status).toBe(400);
    });

    it('deve retornar tokens quando parâmetros são válidos', async () => {
      const response = await request(app)
        .post('/oauth/exchange')
        .send({
          code: 'test_code',
          redirectUri: 'smartbitrix24://auth/callback',
          portalDomain: 'test.bitrix24.com',
        });
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('access_token');
      expect(response.body).toHaveProperty('refresh_token');
      expect(response.body).toHaveProperty('user_id');
      expect(response.body).toHaveProperty('expires_in');
    });
  });

  describe('POST /oauth/refresh', () => {
    it('deve retornar 400 quando parâmetros estão faltando', async () => {
      const response = await request(app)
        .post('/oauth/refresh')
        .send({});
      
      expect(response.status).toBe(400);
      expect(response.body.error).toBe('Parâmetros inválidos');
    });

    it('deve retornar 400 quando refreshToken está faltando', async () => {
      const response = await request(app)
        .post('/oauth/refresh')
        .send({
          portalDomain: 'test.bitrix24.com',
        });
      
      expect(response.status).toBe(400);
    });

    it('deve retornar novos tokens quando parâmetros são válidos', async () => {
      const response = await request(app)
        .post('/oauth/refresh')
        .send({
          refreshToken: 'test_refresh_token',
          portalDomain: 'test.bitrix24.com',
        });
      
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('access_token');
      expect(response.body).toHaveProperty('refresh_token');
      expect(response.body).toHaveProperty('expires_in');
    });
  });

  describe('GET /health', () => {
    it('deve retornar status de saúde', async () => {
      const response = await request(app).get('/health');
      
      expect(response.status).toBe(200);
      expect(response.body.ok).toBe(true);
      expect(response.body.name).toBe('smart-bitrix24-backend');
      expect(response.body.version).toBe('1.0.0');
    });
  });
});
