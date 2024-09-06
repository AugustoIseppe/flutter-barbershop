import express from 'express';
import { upload } from '../multerConfig.js';
import { getBarber, createBarber } from '../controllers/barbershop-barber.js';

const router = express.Router();

router.get('/barber/:barbershopid', getBarber);
router.post('/barber', upload.single("barberimage"), createBarber); //o nome barberimage é o mesmo que está no nome da coluna no banco de dados

export default router;