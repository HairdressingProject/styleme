namespace AdminApi.Helpers
{
    public class AppSettings
    {
        public string Secret { get; set; }
        public string Pepper { get; set; }

        public string CertificateFilename {get; set;}
        public string CertificatePWD { get; set; }
    }
}
