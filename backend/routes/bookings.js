import express from 'express';
import { getBookings, createBooking, getBookingById } from '../controllers/booking.js';

const router = express.Router();

router.get('/bookings', getBookings);
router.get('/bookings/:id', getBookingById);
router.post('/bookings', createBooking);

export default router;
