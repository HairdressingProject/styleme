using System;

namespace AdminApi.Helpers.Exceptions
{
    public class ExistingUserException : ExistingResourceException
    {
        public ExistingUserException() { }

        public ExistingUserException(string msg) : base(msg) { }

        public ExistingUserException(string msg, Exception inner): base(msg, inner) { }
    }
}
