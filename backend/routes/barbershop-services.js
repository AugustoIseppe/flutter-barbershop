import express from 'express';
import { getBarbershopServices, createBarbershopService } from '../controllers/barbershop-service.js';

const router = express.Router();

router.get('/barberServices', getBarbershopServices);
router.post('/barberServices', createBarbershopService);

export default router;