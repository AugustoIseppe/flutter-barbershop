import express from 'express';
import { upload } from '../multerConfig.js';
import { getBarbershops, createBarbershop, getBarbershopsWithServices } from '../controllers/barbershop.js';

const router = express.Router();

router.get('/barbershops', getBarbershops);
router.get('/barbershops/:id', getBarbershopsWithServices);
router.post('/barbershops', upload.single("image"), createBarbershop);

export default router;
