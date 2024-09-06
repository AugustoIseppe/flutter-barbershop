import sql from '../db.js';
import { randomUUID } from 'node:crypto';

export const getBarbershops = async (request, response) => {
    try {
        const barbershops = await sql`select * from "Barbershop"`;
        console.log(barbershops);
        response.status(200).json(barbershops);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao buscar barbearias' });
    }
};


// Lista os serviços de uma barbearia específica
export const getBarbershopsWithServices = async (request, response) => {
    try {
        const { id } = request.params;
        const barbershop = await sql`
        SELECT "BarbershopService".*
        FROM "BarbershopService"
        WHERE "BarbershopService"."barbershopId" = ${id};
        `;

        console.log(barbershop);
        response.status(200).json(barbershop);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao buscar barbearia' });
    }
}


export const createBarbershop = async (request, response) => {
    const uuid = randomUUID();
    console.log(randomUUID);
    try {
        const { name, address, phones, description, imageUrl } = request.body;

        const query = await sql`
            INSERT INTO "Barbershop" (id, name, address, phones, description, "imageUrl") 
            VALUES (${uuid}, ${name}, ${address}, ${phones}, ${description}, ${request.file ? request.file.filename : null}) 
            RETURNING *;
        `;
        console.log(uuid, name, address, phones, description, imageUrl);
        console.log(query);
        response.status(200).json(query);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao criar barbearia' });
    }
};


