using System;

namespace AdminApi.Helpers.Exceptions
{
    public class InvalidQueriesException : Exception
    {
        public InvalidQueriesException() { }

        public InvalidQueriesException(string msg) : base(msg) { }

        public InvalidQueriesException(string msg, Exception inner) : base(msg, inner) { }
    }
}
