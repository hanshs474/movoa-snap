"""Log in to the Snap Store with craft-store and push + release both snaps (run via ./upload.sh)."""
import os, sys, time
from craft_store import UbuntuOneStoreClient, endpoints

client = UbuntuOneStoreClient(
    base_url="https://dashboard.snapcraft.io",
    storage_base_url="https://storage.snapcraftcontent.com",
    auth_url="https://login.ubuntu.com",
    endpoints=endpoints.U1_SNAP_STORE,
    application_name="movoa-upload",
    user_agent="movoa-upload/1",
    environment_auth="SNAPCRAFT_STORE_CREDENTIALS",
    ephemeral=True,
)
kw = dict(email=os.environ["UBUNTU_ONE_EMAIL"], password=os.environ["UBUNTU_ONE_PASSWORD"])
if os.environ.get("UBUNTU_ONE_OTP"):
    kw["otp"] = os.environ["UBUNTU_ONE_OTP"]
client.login(
    permissions=["package_access", "package_push", "package_update", "package_release"],
    description="movoa upload", ttl=3600,
    packages=[endpoints.Package("movoa", "snap")], **kw,
)
print("logged in")

for arch in ("amd64", "arm64"):
    path = f"/b/movoa_0.1.0_{arch}.snap"
    upload_id = client.upload_file(filepath=__import__("pathlib").Path(path))
    r = client.request("POST", "https://dashboard.snapcraft.io/dev/api/snap-push/",
                       json={"name": "movoa", "updown_id": upload_id, "series": "16", "channels": ["stable"]})
    status_url = r.json()["status_details_url"]
    for _ in range(60):
        s = client.request("GET", status_url).json()
        if s.get("processed"):
            print(arch, "revision", s.get("revision"), "errors", s.get("errors"), "released", s.get("channels") or s.get("can_release"))
            break
        time.sleep(5)
    else:
        print(arch, "still processing", s)
