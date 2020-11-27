/// Base URL that connects to the Users API
/// If connecting to EC2: https://api.styleme.best
/// If running on an Android emulator: http://10.0.2.2:5050
/// If running on a real device: Forward ports 5050 and 8000 (chrome://inspect/#devices), then change the URL below to http://localhost:5050
const String USERS_API_URL = 'http://10.0.2.2:5050';

/// Base URL that connects to the Pictures API
/// If connecting to EC2: https://api.styleme.best
/// If running on an Android emulator: http://10.0.2.2:8000
/// If running on a real device: Forward ports 5050 and 8000 (chrome://inspect/#devices), then change the URL below to http://localhost:8000
const String PICTURES_API_URL = 'http://10.0.2.2:8000';

/// Base URL of the Admin Portal, sent in `Origin` request headers
const String ADMIN_PORTAL_URL = 'https://styleme.best';

/// Name of the file to be saved containing the current user's `token`
/// Not being used at the moment
const String TOKEN_FILENAME = 'token.txt';

/// Number of seconds to wait before closing connections to the API
const int DEFAULT_TIMEOUT_SECONDS = 30;
