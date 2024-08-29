import sql from '../db.js';
import { randomUUID } from 'node:crypto';

export const getBarbershopServices = async (req, res) => {
    try {
        const barbershops = await sql`select * from "BarbershopService"`;
        console.log(barbershops);
        res.status(200).json(barbershops);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Erro ao buscar barbearias' });
    }
};


export const createBarbershopService = async (request, response) => {
    const uuid = randomUUID();
    console.log(randomUUID);
    try {
        const { name, description, imageUrl, price, barbershopId} = request.body;

        const query = await sql`
            INSERT INTO "BarbershopService" (id, name, description, "imageUrl", price, "barbershopId") 
            VALUES (${uuid}, ${name}, ${description}, ${imageUrl}, ${price}, ${barbershopId}) 
            RETURNING *;
        `;
        console.log(uuid, name, description, imageUrl, price, barbershopId);
        console.log(query);
        response.status(200).json(query);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao criar barbearia' });
    }
};
