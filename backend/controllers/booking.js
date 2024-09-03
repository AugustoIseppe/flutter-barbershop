import sql from '../db.js';
import { randomUUID } from "node:crypto";

export const getBookings = async (request, response) => {
    try {
        const bookings = await sql`SELECT * FROM "Booking"`;
        console.log(bookings);
        response.status(200).json(bookings);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Erro ao buscar agendamentos" });
    }
};


// export const getBookingById = async (request, response) => {
//     try {
//         const { id } = request.params;

//         // Recupera todas as reservas, serviços associados e informações da barbearia
//         const bookings = await sql`
//             SELECT 
//                 "Booking".*, 
//                 "BarbershopService".*, 
//                 "Barbershop".*
//             FROM 
//                 "Booking"
//             JOIN 
//                 "BookingService" 
//             ON 
//                 "Booking"."id" = "BookingService"."bookingId"
//             JOIN 
//                 "BarbershopService" 
//             ON 
//                 "BookingService"."serviceId" = "BarbershopService"."id"
//             JOIN 
//                 "Barbershop"
//             ON
//                 "BarbershopService"."barbershopId" = "Barbershop"."id"
//             WHERE 
//                 "Booking"."userId" = ${id}
//         `;

//         console.log(bookings);
//         response.status(200).json(bookings);
//     } catch (error) {
//         console.error(error);
//         response.status(500).json({ message: "Erro ao buscar agendamentos" });
//     }
// };


export const getBookingById = async (request, response) => {
    try {
        const { id } = request.params;
        const { barbershopId } = request.query;

        const bookings = await sql`
            SELECT 
                "Booking".*,
                "BarbershopService".* 
            FROM 
                "Booking"
            JOIN 
                "BookingService" 
            ON 
                "Booking"."id" = "BookingService"."bookingId"
            JOIN 
                "BarbershopService" 
            ON 
                "BookingService"."serviceId" = "BarbershopService"."id"
            WHERE 
                "Booking"."userId" = ${id}
                AND "BarbershopService"."barbershopId" = ${barbershopId}
                ORDER BY "Booking"."date" DESC
        `;

        response.status(200).json(bookings);
    } catch (error) {
        console.error("Error in getBookingById:", error);
        response.status(500).json({ message: "Erro ao buscar agendamentos", error: error.message });
    }
};






// export const getBookingById = async (request, response) => {
//     try {
//         const { id } = request.params;

//         // Recupera todas as reservas e os serviços associados
//         const bookings = await sql`
//             SELECT 
//                 "Booking".*,
//                 "BarbershopService".* 
//             FROM 
//                 "Booking"
//             JOIN 
//                 "BookingService" 
//             ON 
//                 "Booking"."id" = "BookingService"."bookingId"
//             JOIN 
//                 "BarbershopService" 
//             ON 
//                 "BookingService"."serviceId" = "BarbershopService"."id"
//             WHERE 
//                 "Booking"."userId" = ${id}
//         `;

//         console.log(bookings);
//         response.status(200).json(bookings);
//     } catch (error) {
//         console.error(error);
//         response.status(500).json({ message: "Erro ao buscar agendamentos" });
//     }
// };






// export const getBookingById = async (request, response) => {
//     try {
//         const { id } = request.params;
//         const bookings = await sql`
//             SELECT 
//                 "Booking".*,
//                 "BarbershopService".* 
//             FROM 
//                 "Booking"
//             JOIN 
//                 "BarbershopService" 
//             ON 
//                 "Booking"."serviceId" = "BarbershopService"."id"
//             WHERE 
//                 "Booking"."userId" = ${id}
//         `;
//         console.log(bookings);
//         response.status(200).json(bookings);
//     } catch (error) {
//         console.error(error);
//         response.status(500).json({ message: "Erro ao buscar agendamentos" });
//     }
// };



export const createBooking = async (request, response) => {
    const bookingId = randomUUID();
    try {
        const { date, time, userId, serviceId } = request.body;

        // Verificação e log do array de serviceId
        if (!Array.isArray(serviceId) || serviceId.length === 0) {
            console.error("Nenhum serviço foi selecionado ou o array de serviceId está vazio.");
            return response.status(400).json({ message: 'Nenhum serviço foi selecionado.' });
        }

        // Inserção na tabela Booking
        const bookingQuery = await sql`
            INSERT INTO "Booking" (id, date, time, "userId") 
            VALUES (${bookingId}, ${date}, ${time} ,${userId})
            RETURNING *;
        `;

        console.log("Booking inserido:", bookingQuery);

        // Inserção na tabela BookingService
        const bookingServiceQueries = serviceId.map(async (id) => {
            return sql`
                INSERT INTO "BookingService" ("bookingId", "serviceId")
                VALUES (${bookingId}, ${id});
            `;
        });

        await Promise.all(bookingServiceQueries);
        console.log("Serviços associados à reserva foram inseridos com sucesso.");

        // Retorno da resposta
        response.status(201).json(bookingQuery);
    } catch (error) {
        console.error("Erro ao criar agendamento:", error);
        response.status(500).json({ message: 'Erro ao criar agendamento' });
    }
};




// SELECT "BarbershopService".*
// FROM "BarbershopService"
// WHERE "BarbershopService"."barbershopId" = ${id};

// export const createBooking = async (request, response) => {
//     const uuid = randomUUID();
//     try {
//         const { date, userId, serviceId } = request.body;

//         const query = await sql`
//             INSERT INTO "Booking" (id, date, "userId", "serviceId") 
//             VALUES (${uuid}, ${date}, ${userId}, ${serviceId})
//             RETURNING *;
//         `;
//         console.log(uuid, date, userId, serviceId);
//         response.status(201).json(query);
//     } catch (error) {
//         console.error(error);
//         response.status(500).json({ message: 'Erro ao criar agendamento' });
//     }
// };
