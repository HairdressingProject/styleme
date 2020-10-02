using System;

namespace UsersAPI.Helpers.Exceptions
{
    public class ExistingResourceException : Exception
    {
        public ExistingResourceException() { }

        public ExistingResourceException(string msg) : base(msg) { }

        public ExistingResourceException(string msg, Exception inner) : base(msg, inner) { }
    }
}
