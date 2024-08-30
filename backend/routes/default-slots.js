import express from 'express';
import { createSlot, getSlots, createAvailableSlot, updateSlot } from '../controllers/slot.js';

const router = express.Router();

router.post('/slots', createSlot);
router.get('/slots', getSlots);
router.post('/slots/available', createAvailableSlot);
router.put('/slots', updateSlot);


export default router;