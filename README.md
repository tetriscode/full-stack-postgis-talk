## Postgis

[PostGIS Home Page](https://postgis.net/install/)

## Create Postgis Extension

\$> psql -h localhost -U postgres -d fullstack -c 'CREATE EXTENSION postgis;'

## Connect to database

    $> psql -h localhost -U fullstack -d fullstack
    $> \c fullstack

## Create Table

    $> CREATE TABLE points (id SERIAL, name TEXT);
    AddGeometryColumn(geom GEOGRAPHY(POINT,4326));

## Geography vs Geometry

### Geography

Spherical - Great Circle Distance

### Geometry

Euclidean / Planar

## Insert Data

    $> INSERT INTO points_simple_g (geom) VALUES ('POINT(1 2)');
    $> INSERT INTO points_simple (geom) VALUES ('SRID-4326;POINT(1 2)');

## Fetch Data

    $> SELECT * FROM points_simple;
    $> SELECT id,geom FROM points_simple;
    $> SELECT id,ST_AsKML(geom) FROM points_simple;

## 3d

    $> INSERT INTO points_simple_3d (geom) VALUES ('SRID=4326;POINT(1 2 3)');
    $> SELECT ST_GeoHash(geom) from points_simple_3d;

## Projections

https://www.youtube.com/watch?v=KUF_Ckv8HbE

## Loading Data

    $> ogr2ogr -f "PostgreSQL" PG:"host=localhost port=5432 dbname=fullstack user=fullstack" states.geojson -nln points -overwrite

    ALTER TABLE states ADD COLUMN name TEXT;

## Query

    $> SELECT * FROM capitals AS c JOIN states AS s ON s.state_name = c.state;

## GeoJSON

    $> ogr2ogr -select BOROUGH,PER_INJ,PED_INJ,PER_KIL,PED_KIL -f "PostgreSQL" PG:"host=localhost port=5432 dbname=fullstack user=fullstack" collision.geojson -nln collision -overwrite

## N Closest

    $> SELECT name,ST_AsGeoJSON(wkb_geometry) FROM capitals WHERE state = 'New York';
    $> SELECT borough, per_inj,
      (SELECT wkb_geometry FROM capitals WHERE state = 'New York') <-> wkb_geometry AS dist_meters
      FROM collision WHERE per_inj > 0 ORDER BY dist_meters;

## Within Distance

    $> SELECT c.borough, ST_Distance(c.wkb_geometry,ref.wkb_geometry) dist
      FROM collision AS c,
      (SELECT wkb_geometry FROM capitals WHERE state = 'New York') As ref(wkb_geometry)
      WHERE ST_DWithin(c.wkb_geometry,ref.wkb_geometry,1000)
      ORDER BY dist;

## Covers

    $> SELECT count(*)
      FROM collision AS c,
      (SELECT wkb_geometry FROM states WHERE state_abbr = 'MO') As ref(wkb_geometry)
      WHERE ST_Covers(ref.wkb_geometry, c.wkb_geometry);

## Delaunay

    $> SELECT ST_AsGeoJSON(ST_DelaunayTriangles(wkb_geometry)) from states WHERE state_abbr = 'MO';

## Simplify

    $> SELECT ST_AsGeoJSON(ST_Simplify(wkb_geometry,0.2)) from states WHERE state_abbr = 'MO';
