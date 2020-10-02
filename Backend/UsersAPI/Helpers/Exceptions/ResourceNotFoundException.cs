using System;

namespace UsersAPI.Helpers.Exceptions
{
    public class ResourceNotFoundException : Exception
    {
        public ResourceNotFoundException() { }

        public ResourceNotFoundException(string msg) : base(msg) { }

        public ResourceNotFoundException(string msg, Exception inner) : base(msg, inner) { }
    }
}
