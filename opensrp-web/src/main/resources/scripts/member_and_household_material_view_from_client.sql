CREATE MATERIALIZED VIEW core."viewJsonDataConversionOfClientRequired"
AS
SELECT DISTINCT c.json->>'baseEntityId' as base_entity_id,
                c.json->'relationships'->'household'->>0 as relation_ship_id,
                (c.json -> 'identifiers'::text) ->> 'Patient_Identifier'::text AS health_id,
                e.json ->> 'providerId'::text AS mhv_name,
                e.json ->> 'team'::text AS cc_name,
                concat(c.json ->> 'firstName'::text, ' ' ,c.json ->> 'lastName'::text ) AS name,
                (c.json -> 'attributes'::text) ->> 'givenNameLocal'::text AS name_bangla,
                CASE WHEN ((c.json -> 'attributes'::text) ->> 'MaritalStatus'::text) = 'Married'::text
                              AND ((c.json -> 'attributes'::text) ->> 'gender'::text) = 'F'::text
                         THEN (c.json -> 'attributes'::text) ->> 'spouseNameEnglish'::text ELSE ''::text
                    END AS husband_name,
                CASE WHEN ((c.json -> 'attributes'::text) ->> 'MaritalStatus'::text) != 'Married'::text
                              OR ((c.json -> 'attributes'::text) ->> 'gender'::text) = 'M'::text
                         THEN (c.json -> 'attributes'::text) ->> 'fatherNameEnglish'::text ELSE ''::text
                    END AS father_name,
                (c.json -> 'attributes'::text) ->> 'motherNameEnglish'::text AS mother_name,
                (c.json ->> 'birthdate'::text)::date AS birth_date,
                CASE WHEN c.json ->> 'gender'::text = 'M'::text THEN 'Male'::text ELSE 'Female'::text END AS gender,
                (c.json -> 'attributes'::text) ->> 'nationalId'::text AS NID,
                (c.json -> 'attributes'::text) ->> 'birthRegistrationID'::text AS BRID,
                (c.json -> 'attributes'::text) ->> 'phoneNumber'::text AS phone_number,
                (c.json -> 'attributes'::text) ->> 'bloodgroup'::text AS blood_group,
                (c.json -> 'attributes'::text) ->> 'Religion'::text AS religion,
                (c.json -> 'attributes'::text) ->> 'permanentAddress'::text AS permanent_address,
                (c.json -> 'attributes'::text) ->> 'postOfficePermanent'::text AS permanent_post_office,
                (c.json -> 'attributes'::text) ->> 'postOfficePresent'::text AS present_post_office,
                (c.json -> 'attributes'::text) ->> 'Disability_Type'::text AS disability_type,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'stateProvince'::text AS present_address_division,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'countyDistrict'::text AS present_address_district,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'cityVillage'::text AS present_address_upazila,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'address1'::text AS present_address_union,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'address2'::text AS present_address_ward,
                (((c.json -> 'addresses'::text) -> 0) -> 'addressFields'::text) ->> 'address7'::text AS present_address_village
FROM core.client c JOIN core.event e ON (c.json -> 'baseEntityId'::text) = (e.json -> 'baseEntityId'::text)
WHERE (e.json ->> 'eventType'::text) ~~ '%Registration%'::text AND c.json->>'gender' != 'H' AND (c.json->>'dateCreated') BETWEEN '2019-06-25T00:00:00.001+06:00' AND '2019-07-10T12:55:27.025+06:00'
WITH DATA;

GRANT ALL PRIVILEGES ON TABLE core."viewJsonDataConversionOfClientRequired" TO opensrp_admin;


CREATE MATERIALIZED VIEW core."viewJsonDataConversionOfClientHousehold" AS
    SELECT DISTINCT ( c.json->>'baseEntityId') AS base_entity_id, (c.json->'attributes'->>'phoneNumber') AS phone_number
    FROM core.client c WHERE c.json->>'gender' = 'H' WITH DATA;

GRANT ALL PRIVILEGES ON TABLE core."viewJsonDataConversionOfClientHousehold" TO opensrp_admin;