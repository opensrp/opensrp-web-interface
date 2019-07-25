SELECT p.base_entity_id, p.health_id, p.mhv_name, p.cc_name, p.name, p.name_bangla,
        p.husband_name, p.husband_name_bangla, p.father_name, p.father_name_bangla, p.mother_name, p.mother_name_bangla,
        p.birth_date, p.gender, '''' || coalesce(p.nid,'') AS nid,'''' || coalesce(p.brid, '') AS brid,
        '''' || coalesce(p.phone_number, '') AS phone_number, '''' || coalesce(h.phone_number, '') AS emergency_phone_number, p.blood_group,
        p.religion, h.permanent_address, h.permanent_post_office, h.present_post_office,
        p.disability_type, p.present_address_division, p.present_address_district,
        p.present_address_upazila, p.present_address_union, p.present_address_ward,
        p.present_address_village FROM core."viewJsonDataConversionOfClientRequired" AS p
    JOIN core."viewJsonDataConversionOfClientHousehold" AS h on p.relation_ship_id = h.base_entity_id;