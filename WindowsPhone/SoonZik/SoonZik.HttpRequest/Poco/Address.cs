namespace SoonZik.HttpRequest.Poco
{
    public class Address
    {
        #region Attributes

        public int Id { get; set; }
        public string NumberStreet { get; set; }
        public object Complement { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Zipcode { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }

        #endregion
    }
}