CREATE OR REPLACE FUNCTION find_in_obj(data json, key varchar) RETURNS VARCHAR AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          // this will either be the value, or undefined
          return obj;
        $$ LANGUAGE plv8 STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION find_in_obj_array(data json, key varchar) RETURNS text[] AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          // this will either be the value, or undefined
          return obj;
        $$ LANGUAGE plv8 STRICT IMMUTABLE;

                CREATE OR REPLACE FUNCTION find_in_obj_int(data json, key varchar) RETURNS INT AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          return Number(obj);
        $$ LANGUAGE plv8 STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION find_in_obj_bool(data json, key varchar) RETURNS BOOLEAN AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          return obj ? 't' : 'f';
        $$ LANGUAGE plv8 STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION find_in_obj_date(data json, key varchar) RETURNS TIMESTAMP WITH TIME ZONE AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          return obj;
        $$ LANGUAGE plv8 STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION find_in_obj_exists(data json, key varchar) RETURNS BOOLEAN AS
        $$
          var obj = data;
          var parts = key.split('.');

          var part = parts.shift();
          while (part) {
            obj = obj[part]
            if (obj === undefined || obj === null) {
               obj = null;
               break;
            }
            part = parts.shift();
          }

          return (obj === undefined || obj === null ? 'f' : 't');
        $$ LANGUAGE plv8 STRICT IMMUTABLE;
