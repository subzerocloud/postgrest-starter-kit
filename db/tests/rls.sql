begin;
select * from no_plan();

SELECT schema_privs_are(
    'api', 'webuser', ARRAY['USAGE'],
    'authenticated users should have usage privilege of the api schema'
);


-- switch to a anonymous application user
set local role anonymous;
set request.jwt.claim.role = 'anonymous';

select set_eq(
    'select id from api.items',
    array[ 1, 3, 6 ],
    'only public items are visible to anonymous users'
);

select set_eq(
    'select id from api.subitems',
    array[ 1, 2, 5, 6, 11, 12 ],
    'only subitems of public items are visible to anonymous users'
);

-- switch to a specific application user
set local role webuser;
set request.jwt.claim.role = 'webuser';
set request.jwt.claim.user_id = '1'; --alice

select set_eq(
    'select id from api.items where mine = true',
    array[ 1, 2, 3 ],
    'can see all his items'
);

select set_eq(
    'select id from api.items',
    array[ 1, 2, 3, 6 ],
    'can see his items and public ones'
);

select set_eq(
    'select id from api.subitems',
    array[ 1, 2, 3, 4, 5, 6, 11, 12 ],
    'can see his subitems and public ones'
);



select * from finish();
rollback;
