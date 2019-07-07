SELECT p.base_entity_id, p.health_id, p.mhv_name, p.cc_name, p.name, p.name_bangla,
       p.husband_name, p.father_name, p.mother_name, p.birth_date, p.gender, p.nid,
       p.brid, p.phone_number, h.phone_number AS emergency_phone_number, p.blood_group,
       p.religion, p.permanent_address, p.permanent_post_office, p.present_post_office,
       p.disability_type, p.present_address_division, p.present_address_district,
       p.present_address_upazila, p.present_address_union, p.present_address_ward,
       p.present_address_village FROM core."viewJsonDataConversionOfClientRequired" AS p
    JOIN core."viewJsonDataConversionOfClientHousehold" AS h on p.relation_ship_id = h.base_entity_id;