using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Fakes;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace ApiUnitTests.Context
{
    public class ColoursContextTests
    {
        private ColoursContext _coloursContext;
        private FakeDatabase _db;

        public ColoursContextTests()
        {
            _db = new FakeDatabase();
            _coloursContext = new ColoursContext(_db.Colours);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfUsers()
        {
            // Arrange     
            _coloursContext = _db.SeedColoursContext();
            List<Colours> expected = _db.Colours;

            // Act
            List<Colours> actual = await _coloursContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredUsers()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            List<Colours> expected = _db.Colours.FindAll(c => c.ColourName == "Blue");

            // Act
            // Equivalent to GET /Colours?limit=1000&offset=0&search=blue
            List<Colours> actual = await _coloursContext.Browse("1000", "0", "blue");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            int expected = _db.Colours.Count;

            // Act
            int actual = await _coloursContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            int expected = 1;

            // Act
            // Equivalent to GET /Colours/count?search=blue
            int actual = await _coloursContext.Count("blue");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsUserById()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            ulong id = 1;
            Colours expected = _db.Colours.FirstOrDefault(c => c.Id == id);

            // Act
            Colours actual = await _coloursContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            ulong id = 2;
            List<Colours> currentColours = _db.Colours;
            Colours current = currentColours.FirstOrDefault(c => c.Id == id);
            Colours updated = current.ShallowCopy();
            updated.ColourHash = "#2517c2";

            Colours updatedColour = new Colours
            {
                Id = id,
                ColourName = updated.ColourName,
                ColourHash = updated.ColourHash
            };

            bool expected = true;

            // Act
            bool actual = await _coloursContext.Edit(id, updatedColour);
            Colours u = _db.Colours.FirstOrDefault(c => c.Id == id);
            _db.Colours = new List<Colours>(currentColours);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedColour.ColourName, updatedColour.ColourName);
            Assert.Equal(updatedColour.ColourHash, u.ColourHash);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsColourAdded()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            int currentColoursCount = _db.Colours.Count;
            List<Colours> currentColours = _db.Colours;

            Colours expected = new Colours
            {
                Id = 3,
                ColourName = "Green",
                ColourHash = "#00FF00"
            };

            // Act
            Colours actual = await _coloursContext.Add(expected);
            int updatedColoursCount = _db.Colours.Count;
            _db.Colours = new List<Colours>(currentColours);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentColoursCount + 1, updatedColoursCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsColourDeleted()
        {
            // Arrange
            _coloursContext = _db.SeedColoursContext();
            ulong id = 2;
            List<Colours> currentColours = _db.Colours;
            int currentColoursCount = _db.Colours.Count;
            Colours expected = _db.Colours.FirstOrDefault(u => u.Id == id);

            // Act
            Colours actual = await _coloursContext.Delete(id);
            int updatedColoursCount = _db.Colours.Count;
            _db.Colours = new List<Colours>(currentColours);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentColoursCount - 1, updatedColoursCount);
        }
    }
}
