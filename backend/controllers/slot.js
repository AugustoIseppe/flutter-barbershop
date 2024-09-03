import sql from '../db.js';
import { randomUUID } from 'node:crypto'; //? -> Importa a função randomUUID da biblioteca crypto do Node.js para gerar um id único 

export const getSlots = async (request, response) => {
    try {
        const { barbershopId, date } = request.query; // Extraindo os parâmetros da query string

        const query = await sql`
SELECT a.*, d.time
FROM "AvailableSlots" AS a
JOIN "DefaultSlots" AS d ON a.timeId = d.id
WHERE a.barbershopId = ${barbershopId}
  AND a.date = ${date}
    AND a.isAvailable = TRUE
    ORDER BY d.time;
        `;
        response.status(200).json(query);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao buscar slots de horário' });
    }
};

export const updateSlot = async (request, response) => {
    try {
        const { id, timeid, date, barbershopid } = request.body;

        // Validação básica para garantir que todos os campos necessários estão presentes
        if (!id || !timeid || !date || !barbershopid) {
            console.log('id:', id, 'timeid:', timeid, 'date:', date, 'barbershopid:', barbershopid);
            return response.status(400).json({ message: 'Todos os parâmetros (id, timeid, date, barbershopid) são necessários.' });
        }
        console.log('id:', id, 'timeid:', timeid, 'date:', date, 'barbershopid:', barbershopid);

        // Atualizar o slot
        const updateQuery = await sql`
            UPDATE "AvailableSlots"
            SET "isavailable" = FALSE
            WHERE "id" = ${id}
              AND "timeid" = ${timeid}
              AND "date" = ${date}
              AND "barbershopid" = ${barbershopid}
              AND "isavailable" = TRUE
            RETURNING *;
        `;

        if (updateQuery.count === 0) {
            return response.status(404).json({ message: 'Slot de horário não encontrado ou já não está disponível' });
        }

        // Buscar o valor do time relacionado ao timeid
        const timeQuery = await sql`
            SELECT "time" 
            FROM "DefaultSlots"
            WHERE "id" = ${timeid};
        `;

        if (timeQuery.count === 0) {
            return response.status(404).json({ message: 'Time associado ao timeid não encontrado.' });
        }

        // Combinar os resultados e retornar a resposta
        const result = {
            ...updateQuery[0], // Dados do slot atualizado
            time: timeQuery[0].time // Valor do time obtido da tabela DefaultSlots
        };

        response.status(200).json(result);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao atualizar slot de horário' });
    }
};





export const createSlot = async (request, response) => {
    const uuid = randomUUID();
    console.log(randomUUID);
    try {
        const { barbershopId, time, date } = request.body;

        const query = await sql`
            INSERT INTO "DefaultSlots" (id, barbershopId, time, date) 
            VALUES (${uuid}, ${barbershopId}, ${time}, ${date}) 
            RETURNING *;
        `;
        console.log(query);
        response.status(200).json(query);
    } catch (error) {
        console.error(error);
        response.status(500).json({ message: 'Erro ao criar slot de horário' });
    }
};

export const createAvailableSlot = async (request, response) => {
    try {
        const { barbershopId, date } = request.body;

        // Pega os horários da DefaultSlots para o dia especificado
        const defaultSlots = await sql`
            SELECT * FROM "DefaultSlots"
            WHERE barbershopId = ${barbershopId} AND date = ${date};
        `;

        if (defaultSlots.length === 0) {
            return response.status(404).json({ message: 'Nenhum horário padrão encontrado para o dia especificado.' });
        }

        // Insere esses horários na tabela AvailableSlots
        const promises = defaultSlots.map(slot => {
            return sql`
                INSERT INTO "AvailableSlots" (id, barbershopid, date, timeid, isavailable, createdAt, updatedAt)
                VALUES (${randomUUID()}, ${barbershopId}, ${date}, ${slot.id}, TRUE, NOW(), NOW());
            `;
        });

        await Promise.all(promises);
        response.status(200).json({ message: 'Horários disponíveis criados com sucesso.' });
    } catch (error) {
        console.error('Error details:', error);
        response.status(500).json({ message: 'Erro ao criar horários disponíveis.' });
    }
};




// UPDATE "DefaultSlots"
//             SET barbershopId = ${barbershopId}, time = ${time}, date = ${date}
//             WHERE id = ${id}
//             RETURNING *;





