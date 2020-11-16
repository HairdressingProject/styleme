/// Base URL that connects to the Users API
const String USERS_API_URL = 'http://10.0.2.2:5050';

/// Base URL that connects to the Pictures API
const String PICTURES_API_URL = 'http://10.0.2.2:8000';

/// Base URL of the Admin Portal, sent in `Origin` request headers
const String ADMIN_PORTAL_URL = 'https://styleme.best';

/// Name of the file to be saved containing the current user's `token`
const String TOKEN_FILENAME = 'token.txt';

/// Number of seconds to wait before closing connections to the API
const int DEFAULT_TIMEOUT_SECONDS = 30;
