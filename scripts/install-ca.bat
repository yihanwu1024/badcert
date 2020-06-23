for %%f in (%~dp0\..\cer\ca\*.cer) do certutil -addstore -ent -f "Disallowed" "%%f"
