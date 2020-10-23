import json

from fastapi import FastAPI, APIRouter, Request, Response, status
from fastapi.middleware.httpsredirect import HTTPSRedirectMiddleware
from fastapi.responses import ORJSONResponse
import requests
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from uvicorn.middleware.proxy_headers import ProxyHeadersMiddleware
from app.database.db import SessionLocal, engine, Base
from app.settings import API_HOST, ADMIN_PORTAL_HOST, USERS_API_URL
from .routers import get_user_data_from_token

from app.routers import pictures
from app.routers import model_pictures
from app.routers import history
from app.routers import test
import time

Base.metadata.create_all(bind=engine)

app = FastAPI()


# Middleware
@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    start_time = time.time()
    response: Response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time-ms"] = str(process_time * 1000)
    return response


@app.middleware("http")
async def authorise_user(request: Request, call_next):
    # TODO: check request URL before running this middleware
    # Certain routes need to access user data (such as POST /pictures)
    # In that case, this middleware should be skipped and the logic should move to the route itself
    print(request.url.path)
    print(request.method)

    if '/pictures' not in request.url.path and request.method != 'POST':
        user_data = get_user_data_from_token(request=request)

        if user_data:
            response: Response = await call_next(request)
            return response

        return ORJSONResponse(
            status_code=status.HTTP_401_UNAUTHORIZED,
            content={
                "message": "Invalid credentials"
            }
        )
    
    response: Response = await call_next(request)
    return response


# Use the ones below in a production environment
"""
app.add_middleware(HTTPSRedirectMiddleware)

app.add_middleware(
    TrustedHostMiddleware, allowed_hosts=[ADMIN_PORTAL_HOST, "*." + ADMIN_PORTAL_HOST]
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://" + ADMIN_PORTAL_HOST, "https://api." + ADMIN_PORTAL_HOST],
    allow_credentials=True,
    allow_methods=["GET", "PUT", "POST", "DELETE"],
    allow_headers=["*"]
)

app.add_middleware(GZipMiddleware)

app.add_middleware(ProxyHeadersMiddleware)


@app.middleware("http")
async def authorise_user(request: Request, call_next):
    if "authorization" not in request.headers.keys() and "auth" not in request.cookies.keys():
        print(f"No authorization header or auth cookie found")
        return ORJSONResponse(
            status_code=status.HTTP_401_UNAUTHORIZED,
            content={
                "message": "Please sign in first"
            }
        )

    authorization_header = request.headers.get("authorization")
    auth_cookie = request.cookies.get("auth")

    print(f"Authorization: {authorization_header}")
    print(f"Auth cookie: {auth_cookie}")

    users_api_req_headers = {
        "origin": f"https://{ADMIN_PORTAL_HOST}"
    }

    if authorization_header:
        users_api_req_headers["authorization"] = authorization_header

    if auth_cookie:
        users_api_req_headers["cookie"] = f"auth={auth_cookie}"

    users_api_response = requests.get(f"{USERS_API_URL}/users/authenticate", headers=users_api_req_headers)
    print("Response from users API:")
    try:
        print(users_api_response.json())
    except json.decoder.JSONDecodeError:
        pass

    if users_api_response.ok:
        response: Response = await call_next(request)
        return response

    return ORJSONResponse(
        status_code=status.HTTP_401_UNAUTHORIZED,
        content={
            "message": "Invalid credentials"
        }
    )

"""

api_router = APIRouter()
api_router.include_router(pictures.router, prefix="/pictures", tags=["Pictures"])
api_router.include_router(model_pictures.router, prefix="/models", tags=["ModelPictures"])
api_router.include_router(history.router, prefix="/history", tags=["History"],
                          responses={404: {"description": "Not found"}})
api_router.include_router(test.router, tags=["test"])

app.include_router(api_router)
