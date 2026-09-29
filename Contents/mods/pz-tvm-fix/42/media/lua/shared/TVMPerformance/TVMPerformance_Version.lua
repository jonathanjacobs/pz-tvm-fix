-- TVM Network Tuner - build version
--
-- The one place the runtime build version is defined. Keep it equal to the
-- repository VERSION file; tools/validate-package.sh checks this. The server
-- CONFIG line, load banners, and the buildVersion field in the BuildState
-- server-to-client message all read it from here, so clients and servers can
-- detect a mixed-version install (see "Build stamp and version handshake" in
-- docs/DESIGN.md).

local Version = {
    BUILD_VERSION = "0.3.0-beta",
}

return Version
