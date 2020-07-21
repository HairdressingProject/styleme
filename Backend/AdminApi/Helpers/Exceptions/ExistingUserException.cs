using System;

namespace AdminApi.Helpers.Exceptions
{
    public class ExistingUserException : Exception
    {
        public ExistingUserException() { }

        public ExistingUserException(string msg) : base(msg) { }

        public ExistingUserException(string msg, Exception inner): base(msg, inner) { }
    }
}
