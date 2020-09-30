from fastapi import APIRouter, File, Depends, UploadFile, status
router = APIRouter()


@router.get("/test")
def test():
    return {"Test OK"}