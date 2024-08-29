import express from 'express';
import { createSlot, getSlots, createAvailableSlot } from '../controllers/slot.js';

const router = express.Router();

router.post('/slots', createSlot);
router.get('/slots', getSlots);
router.post('/slots/available', createAvailableSlot);


export default router;