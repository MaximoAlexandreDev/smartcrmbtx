/**
 * Testes para Rate Limiting
 * Copyright (c) Maximo Tecnologia 2025
 */

import { RateLimiterMemory } from 'rate-limiter-flexible';
import { describe, it, expect } from '@jest/globals';

describe('Rate Limiter', () => {
  it('deve permitir requests dentro do limite', async () => {
    const limiter = new RateLimiterMemory({
      points: 5,
      duration: 1,
    });

    const ip = '127.0.0.1';
    
    // Deve permitir 5 requests
    for (let i = 0; i < 5; i++) {
      await expect(limiter.consume(ip)).resolves.toBeDefined();
    }
  });

  it('deve bloquear requests acima do limite', async () => {
    const limiter = new RateLimiterMemory({
      points: 3,
      duration: 1,
    });

    const ip = '127.0.0.2';
    
    // Consome 3 pontos
    for (let i = 0; i < 3; i++) {
      await limiter.consume(ip);
    }

    // O 4º deve falhar
    await expect(limiter.consume(ip)).rejects.toThrow();
  });

  it('deve resetar após a duração', async () => {
    const limiter = new RateLimiterMemory({
      points: 2,
      duration: 1, // 1 segundo
    });

    const ip = '127.0.0.3';
    
    // Consome 2 pontos
    await limiter.consume(ip);
    await limiter.consume(ip);

    // Aguarda 1.1 segundo para resetar
    await new Promise(resolve => setTimeout(resolve, 1100));

    // Deve permitir novamente
    await expect(limiter.consume(ip)).resolves.toBeDefined();
  });
});
