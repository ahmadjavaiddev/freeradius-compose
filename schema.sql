-- NAS (Network Access Servers / Routers)
CREATE TABLE IF NOT EXISTS nas (
  id SERIAL PRIMARY KEY,
  nasname TEXT NOT NULL,
  shortname TEXT,
  type TEXT DEFAULT 'other',
  ports INT,
  secret TEXT NOT NULL,
  server TEXT,
  community TEXT,
  description TEXT
);
CREATE INDEX IF NOT EXISTS nas_nasname ON nas (nasname);

-- User authentication checks
CREATE TABLE IF NOT EXISTS radcheck (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '==',
  value TEXT NOT NULL DEFAULT ''
);
CREATE INDEX IF NOT EXISTS radcheck_username ON radcheck (username, attribute);

-- User authentication replies (attributes sent back on accept)
CREATE TABLE IF NOT EXISTS radreply (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '=',
  value TEXT NOT NULL DEFAULT ''
);
CREATE INDEX IF NOT EXISTS radreply_username ON radreply (username, attribute);

-- Group authentication checks
CREATE TABLE IF NOT EXISTS radgroupcheck (
  id SERIAL PRIMARY KEY,
  groupname TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '==',
  value TEXT NOT NULL DEFAULT ''
);
CREATE INDEX IF NOT EXISTS radgroupcheck_groupname ON radgroupcheck (groupname, attribute);

-- Group replies (speed limits etc sent back for group members)
CREATE TABLE IF NOT EXISTS radgroupreply (
  id SERIAL PRIMARY KEY,
  groupname TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '=',
  value TEXT NOT NULL DEFAULT ''
);
CREATE INDEX IF NOT EXISTS radgroupreply_groupname ON radgroupreply (groupname, attribute);

-- User to group mapping
CREATE TABLE IF NOT EXISTS radusergroup (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  groupname TEXT NOT NULL DEFAULT '',
  priority INT NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS radusergroup_username ON radusergroup (username);

-- Accounting (live and historical session data)
CREATE TABLE IF NOT EXISTS radacct (
  radacctid BIGSERIAL PRIMARY KEY,
  acctsessionid TEXT NOT NULL,
  acctuniqueid TEXT NOT NULL UNIQUE,
  username TEXT,
  groupname TEXT,
  realm TEXT,
  nasipaddress INET NOT NULL,
  nasportid TEXT,
  nasporttype TEXT,
  acctstarttime TIMESTAMPTZ,
  acctupdatetime TIMESTAMPTZ,
  acctstoptime TIMESTAMPTZ,
  acctinterval BIGINT,
  acctsessiontime BIGINT,
  acctauthentic TEXT,
  connectinfo_start TEXT,
  connectinfo_stop TEXT,
  acctinputoctets BIGINT,
  acctoutputoctets BIGINT,
  calledstationid TEXT,
  callingstationid TEXT,
  acctterminatecause TEXT,
  servicetype TEXT,
  framedprotocol TEXT,
  framedipaddress INET,
  framedipv6address INET,
  framedipv6prefix INET,
  framedinterfaceid TEXT,
  delegatedipv6prefix INET,
  class TEXT
);
CREATE INDEX IF NOT EXISTS radacct_start_user_idx ON radacct (acctstarttime, username);
CREATE INDEX IF NOT EXISTS radacct_active_session_idx ON radacct (acctuniqueid) WHERE acctstoptime IS NULL;
CREATE INDEX IF NOT EXISTS radacct_bulk_close ON radacct (nasipaddress, acctstarttime) WHERE acctstoptime IS NULL;
CREATE INDEX IF NOT EXISTS radacct_bulk_timeout ON radacct (acctstoptime, acctupdatetime);

-- Post-auth log (every accept and reject)
CREATE TABLE IF NOT EXISTS radpostauth (
  id BIGSERIAL PRIMARY KEY,
  username TEXT NOT NULL,
  pass TEXT,
  reply TEXT,
  calledstationid TEXT,
  callingstationid TEXT,
  authdate TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  class TEXT
);

-- Reload tracking for NAS
CREATE TABLE IF NOT EXISTS nasreload (
  nasipaddress INET PRIMARY KEY,
  reloadtime TIMESTAMPTZ NOT NULL
);