import express from 'express';
import { getBarbershops, createBarbershop, getBarbershopsWithServices } from '../controllers/barbershop.js';

const router = express.Router();

router.get('/barbershops', getBarbershops);
router.get('/barbershops/:id', getBarbershopsWithServices);
router.post('/barbershops', createBarbershop);

export default router;
