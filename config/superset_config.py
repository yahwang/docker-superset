import os

MAPBOX_API_KEY = os.getenv('MAPBOX_API_KEY', '')

SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://superset:superset@superset_postgres:5432/superset'
#SQLALCHEMY_TRACK_MODIFICATIONS = True
SECRET_KEY = os.getenv('SECRET_KEY', 'thisISaSECRET_1234')


# chart & dashboard caching
CACHE_DEFAULT_TIMEOUT = 60 * 60 * 24 # 1 day default

CACHE_CONFIG = {
    'CACHE_TYPE': 'redis',
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_URL': 'redis://superset_redis:6379/1'}

#HTTP_HEADERS = {'X-Frame-Options': 'SAMEORIGIN'}
# If you need to allow iframes from other domains (and are
# aware of the risks), you can disable this header:
HTTP_HEADERS = {}
