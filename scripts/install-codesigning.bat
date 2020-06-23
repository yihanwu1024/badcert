for %%f in (%~dp0\..\cer\codesigning\*.cer) do certutil -addstore -ent -f "Disallowed" "%%f"
