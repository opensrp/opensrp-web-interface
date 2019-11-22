--update event_metadata
UPDATE core.event_metadata
SET    provider_id = ut.provider_id
FROM   (SELECT cem.base_entity_id be_id,
               cem.provider_id    pid,
               adt.provider_id
        FROM   core.event_metadata cem
               JOIN (SELECT em.*,
                            cm.relational_id
                     FROM   core.event_metadata em
                            JOIN core.client_metadata cm
                              ON cm.base_entity_id = em.base_entity_id
                     WHERE  em.entity_type != 'ec_household'
                            AND em.provider_id != '') adt
                 ON adt.relational_id = cem.base_entity_id
        WHERE  cem.entity_type = 'ec_household'
               AND cem.provider_id = ''
               AND adt.relational_id = cem.base_entity_id) ut
WHERE  ut.be_id = base_entity_id;


--update event

UPDATE core.event
SET    json = Replace(json :: text, '"providerId": ""',
                            Concat('"providerId": ', '"', ut.pid, '"')) :: jsonb
FROM   (SELECT em.base_entity_id       be_id,
               em.provider_id          pid,
               e.json ->> 'providerId' AS p_id
        FROM   core.event_metadata em
               JOIN core.event e
                 ON e.json ->> 'baseEntityId' :: text = em.base_entity_id
        WHERE  em.entity_type = 'ec_household'
               AND e.json ->> 'providerId' = ''
               AND em.provider_id != ''
               AND em.base_entity_id = e.json ->> 'baseEntityId') ut
WHERE  ut.be_id = json ->> 'baseEntityId'
       AND json ->> 'providerId' = '';
