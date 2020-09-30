using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Fakes;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace ApiUnitTests.Context
{
    public class HairStylesContextTests
    {
        private HairStylesContext _hairStylesContext;
        private FakeDatabase _db;

        public HairStylesContextTests()
        {
            _db = new FakeDatabase();
            _hairStylesContext = new HairStylesContext(_db.HairStyles);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfHairStyles()
        {
            // Arrange     
            _hairStylesContext = _db.SeedHairStylesContext();
            List<HairStyles> expected = _db.HairStyles;

            // Act
            List<HairStyles> actual = await _hairStylesContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredHairStyles()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            List<HairStyles> expected = _db.HairStyles.FindAll(hs => hs.HairStyleName == "bob");

            // Act
            // Equivalent to GET /hair_styles?limit=1000&offset=0&search=bob
            List<HairStyles> actual = await _hairStylesContext.Browse("1000", "0", "bob");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            int expected = _db.HairStyles.Count;

            // Act
            int actual = await _hairStylesContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            int expected = 1;

            // Act
            // Equivalent to GET /hair_styles/count?search=bob
            int actual = await _hairStylesContext.Count("bob");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsHairStyleById()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            ulong id = 1;
            HairStyles expected = _db.HairStyles.FirstOrDefault(c => c.Id == id);

            // Act
            HairStyles actual = await _hairStylesContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            ulong id = 2;
            List<HairStyles> currentHairStyles = _db.HairStyles;
            HairStyles current = currentHairStyles.FirstOrDefault(c => c.Id == id);
            HairStyles updated = current.ShallowCopy();
            updated.HairStyleName = "mohawk";

            HairStyles updatedHairStyle = new HairStyles
            {
                Id = id,
                HairStyleName = updated.HairStyleName
            };

            bool expected = true;

            // Act
            bool actual = await _hairStylesContext.Edit(id, updatedHairStyle);
            HairStyles u = _db.HairStyles.FirstOrDefault(c => c.Id == id);
            _db.HairStyles = new List<HairStyles>(currentHairStyles);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedHairStyle.HairStyleName, u.HairStyleName);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsHairStyleAdded()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            int currentHairStylesCount = _db.HairStyles.Count;
            List<HairStyles> currentHairStyles = _db.HairStyles;

            HairStyles expected = new HairStyles
            {
                Id = 3,
                HairStyleName = "wavy"
            };

            // Act
            HairStyles actual = await _hairStylesContext.Add(expected);
            int updatedHairStylesCount = _db.HairStyles.Count;
            _db.HairStyles = new List<HairStyles>(currentHairStyles);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairStylesCount + 1, updatedHairStylesCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsHairStyleDeleted()
        {
            // Arrange
            _hairStylesContext = _db.SeedHairStylesContext();
            ulong id = 2;
            List<HairStyles> currentHairStyles = _db.HairStyles;
            int currentHairStylesCount = _db.HairStyles.Count;
            HairStyles expected = _db.HairStyles.FirstOrDefault(u => u.Id == id);

            // Act
            HairStyles actual = await _hairStylesContext.Delete(id);
            int updatedHairStylesCount = _db.HairStyles.Count;
            _db.HairStyles = new List<HairStyles>(currentHairStyles);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentHairStylesCount - 1, updatedHairStylesCount);
        }
    }
}
