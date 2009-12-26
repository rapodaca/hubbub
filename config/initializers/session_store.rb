# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hubbub_session',
  :secret      => '69306fa10d32797bcc1d2f63c6b071b88bc8d00722402f4fb925e1ac4cb8a08684d1162c43e2c578833385031a9bf645b73991823ccca66f75b02b96f9cf3e03'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
