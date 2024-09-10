import express from 'express';
import { upload } from '../multerConfig.js';
import { getBarber, bestRatedBarbers, createBarber, deleteBarber } from '../controllers/barbershop-barber.js';

const router = express.Router();

router.get('/barber/:barbershopid', getBarber);
router.get('/barber/bestRated', bestRatedBarbers);
router.post('/barber', upload.single("barberimage"), createBarber); //o nome barberimage é o mesmo que está no nome da coluna no banco de dados
router.delete('/barber/:id', deleteBarber);

export default router;