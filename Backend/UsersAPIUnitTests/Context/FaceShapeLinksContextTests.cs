using UsersAPI.Models;
using UsersAPI.Services.Context;
using UsersAPIUnitTests.Fakes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace UsersAPIUnitTests.Context
{
    public class FaceShapeLinksContextTests
    {
        private FaceShapeLinksContext _faceShapeLinksContext;
        private FakeDatabase _db;

        public FaceShapeLinksContextTests()
        {
            _db = new FakeDatabase();
            _faceShapeLinksContext = new FaceShapeLinksContext(_db.FaceShapeLinks);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfFaceShapeLinks()
        {
            // Arrange     
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            List<FaceShapeLinks> expected = _db.FaceShapeLinks;

            // Act
            List<FaceShapeLinks> actual = await _faceShapeLinksContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredFaceShapeLinks()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            List<FaceShapeLinks> expected = _db.FaceShapeLinks.FindAll(c => 
            c.LinkName.Trim().ToLower().Contains("oval"));

            // Act
            // Equivalent to GET /face_shape_links?limit=1000&offset=0&search=oval
            List<FaceShapeLinks> actual = await _faceShapeLinksContext.Browse("1000", "0", "oval");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            int expected = _db.FaceShapeLinks.Count;

            // Act
            int actual = await _faceShapeLinksContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            int expected = 1;

            // Act
            // Equivalent to GET /face_shape_links/count?search=oval
            int actual = await _faceShapeLinksContext.Count("oval");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsFaceShapeLinksById()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            ulong id = 1;
            FaceShapeLinks expected = _db.FaceShapeLinks.FirstOrDefault(c => c.Id == id);

            // Act
            FaceShapeLinks actual = await _faceShapeLinksContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            ulong id = 2;
            List<FaceShapeLinks> currentFaceShapeLinks = _db.FaceShapeLinks;
            FaceShapeLinks current = currentFaceShapeLinks.FirstOrDefault(c => c.Id == id);
            FaceShapeLinks updated = current.ShallowCopy();
            updated.LinkName = "square links";
            updated.LinkUrl = "https://scstylecaster.files.wordpress.com/2016/05/olivia-wilde-square-face.jpg";

            FaceShapeLinks updatedFaceShapeLink = new FaceShapeLinks
            {
                Id = id,
                LinkName = updated.LinkName,
                LinkUrl = updated.LinkUrl,
                FaceShapeId = updated.FaceShapeId
            };

            bool expected = true;

            // Act
            bool actual = await _faceShapeLinksContext.Edit(id, updatedFaceShapeLink);
            FaceShapeLinks u = _db.FaceShapeLinks.FirstOrDefault(fs => fs.Id == id);
            _db.FaceShapeLinks = new List<FaceShapeLinks>(currentFaceShapeLinks);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedFaceShapeLink.LinkUrl, u.LinkUrl);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsFaceShapeLinkAdded()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            int currentFaceShapeLinksCount = _db.FaceShapeLinks.Count;
            List<FaceShapeLinks> currentFaceShapeLinks = _db.FaceShapeLinks;

            FaceShapeLinks expected = new FaceShapeLinks
            {
                Id = 3,
                LinkName = "rectangular link 2",
                LinkUrl = "https://www.prettyyourworld.com/assets/public/images/rectangle%20-%20face%20-Depositphotos_4210529_xl-2015.jpg",
                FaceShapeId = 2
            };

            // Act
            FaceShapeLinks actual = await _faceShapeLinksContext.Add(expected);
            int updatedFaceShapeLinksCount = _db.FaceShapeLinks.Count;
            _db.FaceShapeLinks = new List<FaceShapeLinks>(currentFaceShapeLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentFaceShapeLinksCount + 1, updatedFaceShapeLinksCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsFaceShapeDeleted()
        {
            // Arrange
            _faceShapeLinksContext = _db.SeedFaceShapeLinksContext();
            ulong id = 2;
            List<FaceShapeLinks> currentFaceShapeLinks = _db.FaceShapeLinks;
            int currentFaceShapeLinksCount = _db.FaceShapeLinks.Count;
            FaceShapeLinks expected = _db.FaceShapeLinks.FirstOrDefault(u => u.Id == id);

            // Act
            FaceShapeLinks actual = await _faceShapeLinksContext.Delete(id);
            int updatedFaceShapeLinksCount = _db.FaceShapeLinks.Count;
            _db.FaceShapeLinks = new List<FaceShapeLinks>(currentFaceShapeLinks);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentFaceShapeLinksCount - 1, updatedFaceShapeLinksCount);
        }
    }
}
