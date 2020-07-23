using AdminApi.Models_v2_1;
using AdminApi.Services.Context;
using ApiUnitTests.Fakes;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace ApiUnitTests.Context
{
    public class FaceShapesContextTests
    {
        private FaceShapesContext _faceShapesContext;
        private FakeDatabase _db;

        public FaceShapesContextTests()
        {
            _db = new FakeDatabase();
            _faceShapesContext = new FaceShapesContext(_db.FaceShapes);
        }

        [Fact(DisplayName = "Browse all")]
        public async Task Browse_ReturnsListOfFaceShapes()
        {
            // Arrange     
            _faceShapesContext = _db.SeedFaceShapesContext();
            List<FaceShapes> expected = _db.FaceShapes;

            // Act
            List<FaceShapes> actual = await _faceShapesContext.Browse();

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Browse filtered")]
        public async Task Browse_Limit_Offset_Search_ReturnsFilteredFaceShapes()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            List<FaceShapes> expected = _db.FaceShapes.FindAll(c => c.ShapeName == "oval");

            // Act
            // Equivalent to GET /face_shapes?limit=1000&offset=0&search=oval
            List<FaceShapes> actual = await _faceShapesContext.Browse("1000", "0", "oval");

            // Assert
            Assert.Equal(expected.Count, actual.Count);
        }

        [Fact(DisplayName = "Count all")]
        public async Task Count_ReturnsTotal()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            int expected = _db.FaceShapes.Count;

            // Act
            int actual = await _faceShapesContext.Count();

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Count filtered")]
        public async Task Count_ReturnsFilteredCount()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            int expected = 1;

            // Act
            // Equivalent to GET /face_shapes/count?search=oval
            int actual = await _faceShapesContext.Count("oval");

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Read")]
        public async Task Read_ReturnsFaceShapeById()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            ulong id = 1;
            FaceShapes expected = _db.FaceShapes.FirstOrDefault(c => c.Id == id);

            // Act
            FaceShapes actual = await _faceShapesContext.ReadById(id);

            // Assert
            Assert.Equal(expected, actual);
        }

        [Fact(DisplayName = "Edit")]
        public async Task Edit_ReturnsTrue()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            ulong id = 2;
            List<FaceShapes> currentFaceShapes = _db.FaceShapes;
            FaceShapes current = currentFaceShapes.FirstOrDefault(c => c.Id == id);
            FaceShapes updated = current.ShallowCopy();
            updated.ShapeName = "square";

            FaceShapes updatedFaceShape = new FaceShapes
            {
                Id = id,
                ShapeName = updated.ShapeName
            };

            bool expected = true;

            // Act
            bool actual = await _faceShapesContext.Edit(id, updatedFaceShape);
            FaceShapes u = _db.FaceShapes.FirstOrDefault(fs => fs.Id == id);
            _db.FaceShapes = new List<FaceShapes>(currentFaceShapes);

            // Assert
            Assert.Equal(expected, actual);
            Assert.Equal(updatedFaceShape.ShapeName, updatedFaceShape.ShapeName);
        }

        [Fact(DisplayName = "Add")]
        public async Task Add_ReturnsFaceShapeAdded()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            int currentFaceShapesCount = _db.FaceShapes.Count;
            List<FaceShapes> currentFaceShapes = _db.FaceShapes;

            FaceShapes expected = new FaceShapes
            {
                Id = 3,
                ShapeName = "round"
            };

            // Act
            FaceShapes actual = await _faceShapesContext.Add(expected);
            int updatedFaceShapesCount = _db.FaceShapes.Count;
            _db.FaceShapes = new List<FaceShapes>(currentFaceShapes);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentFaceShapesCount + 1, updatedFaceShapesCount);
        }

        [Fact(DisplayName = "Delete")]
        public async Task Delete_ReturnsFaceShapeDeleted()
        {
            // Arrange
            _faceShapesContext = _db.SeedFaceShapesContext();
            ulong id = 2;
            List<FaceShapes> currentFaceShapes = _db.FaceShapes;
            int currentFaceShapesCount = _db.FaceShapes.Count;
            FaceShapes expected = _db.FaceShapes.FirstOrDefault(u => u.Id == id);

            // Act
            FaceShapes actual = await _faceShapesContext.Delete(id);
            int updatedFaceShapesCount = _db.FaceShapes.Count;
            _db.FaceShapes = new List<FaceShapes>(currentFaceShapes);

            // Assert
            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(currentFaceShapesCount - 1, updatedFaceShapesCount);
        }
    }
}
