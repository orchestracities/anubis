#!/bin/bash -e

#export token="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwb1A0UHVVdDZBOWYxODcxSGRzQ1MtQnRZdEo3MTVHaVZPclVJdGZCMGN3In0.eyJqdGkiOiJiZTRjNzA2YS0wYTY0LTQ0MGUtOWEwZC0yMTdlYzI0YTc2OTYiLCJleHAiOjE2MDc5OTE2NzUsIm5iZiI6MCwiaWF0IjoxNjA3OTU1Njc1LCJpc3MiOiJodHRwczovL2F1dGguZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20vYXV0aC9yZWFsbXMvZGVmYXVsdCIsInN1YiI6IjYzMWE3ODBkLWM3YTItNGI2YS1hY2Q4LWU4NTYzNDhiY2IyZSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFwaSIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6IjU4YjkwNjQxLTM2N2QtNGEzMy1hZjZiLTgwMGFiMWRkODUwNCIsImFjciI6IjEiLCJzY29wZSI6ImVudGl0eTpkZWxldGUgZW50aXR5OmNyZWF0ZSBkZXZpY2U6ZGF0YSBwcm9maWxlIGVudGl0eXR5cGU6cmVhZCBlbnRpdHk6cmVhZCBlbnRpdHk6d3JpdGUgZW1haWwgdGVuYW50cyBzdWJzY3JpcHRpb246cmVhZCIsImZpd2FyZS1zZXJ2aWNlcyI6eyJFS1oiOlsiL1dhc3RlTWFuYWdlbWVudC9EZW1vIiwiL1BhcmtpbmdNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L1BuaSIsIi9Qb3dlck1hbmFnZW1lbnQvRXNhdmUiLCIvTW9iaWxpdHlNYW5hZ2VtZW50IiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9OYWJlbCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvT3BlbldlYXRoZXIiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1ZhaXNhbGEiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1NtYXJ0U2Vuc2UiLCIvVHJhZmZpY01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RlbW8iLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L1B1cnBsZUFpciIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvS2VhY291c3RpY3MiLCIvUGFya2luZ01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9NZXRlb1N3aXNzIiwiL1BhcmtpbmdNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQWVyb3F1YWwiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50L0RhdGFrb3J1bSIsIi9QYXJraW5nTWFuYWdlbWVudC9OZWRhcCIsIi9QYXJraW5nTWFuYWdlbWVudC9DaXRpbG9nIiwiL1BhcmtpbmdNYW5hZ2VtZW50L09wZW5DaGFyZ2VNYXAiLCIvV2FzdGVNYW5hZ2VtZW50L1NlbnNvbmVvIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9XQVFJIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudCIsIi9QYXJraW5nTWFuYWdlbWVudC9DbGV2ZXJjaXRpIiwiL1dhc3RlTWFuYWdlbWVudCIsIi9XYXN0ZU1hbmFnZW1lbnQvRWNvbW9iaWxlIiwiL0luZnJhc3RydWN0dXJlTWFuYWdlbWVudC9EZWNlbnRsYWIiLCIvVHJhZmZpY01hbmFnZW1lbnQvQ2l0aWxvZyIsIi9UcmFmZmljTWFuYWdlbWVudCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvQ2VzdmEiLCIvVHJhZmZpY01hbmFnZW1lbnQvSEVSRSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvSGF3YURhd2EiLCIvRW52aXJvbm1lbnRNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L0VLWiJdfSwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiYXBpIGFwaSIsInByZWZlcnJlZF91c2VybmFtZSI6ImFwaUBla3oub3JjaGVzdHJhY2l0aWVzLmNvbSIsImxvY2FsZSI6ImVuIiwiZ2l2ZW5fbmFtZSI6ImFwaSIsImZhbWlseV9uYW1lIjoiYXBpIiwiZW1haWwiOiJhcGlAZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20ifQ.Mh-BMwUX8R7d3FD8sX9stkpifOvL-5gPez68Dmghek0aiH-ESN9I9cm1c8y8v7fRcAtTV9_XwOKoi8OC50cQQY41ZHoWfD4QVo4iN24kYaKr19DRyra1GmHra4ev0CEDhmxe3qPODFanA2mMIrfA7LmCvzrStcfdFmPs0nMv4-Ef0iGbU6-vVTMSDmqF5jzDlL__sIzRLafXdQ0cOurl0sR3CTV4UzFk3zRiUi-Z1AvTBIPNc_NJ5Fe1owz5-s8aehcD-w-9JUF5ecRA_94qjc65_D5CLtzhSC5WXmGy_UTqtMf4BZtpE_hNNvJwvfTGtsxNbq63ZGiJ6BVJScL2nQ"

export token="eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJwb1A0UHVVdDZBOWYxODcxSGRzQ1MtQnRZdEo3MTVHaVZPclVJdGZCMGN3In0.eyJqdGkiOiJmY2FlOGMxYS1hNGZmLTQwNzItYTBiMy02MTgyMWIyNjJhNzQiLCJleHAiOjE2MzkwMDg0MjgsIm5iZiI6MCwiaWF0IjoxNjM4OTcyNDI4LCJpc3MiOiJodHRwczovL2F1dGguZWt6Lm9yY2hlc3RyYWNpdGllcy5jb20vYXV0aC9yZWFsbXMvZGVmYXVsdCIsImF1ZCI6ImFkbWluLWNsaSIsInN1YiI6IjFjNGY5ZjgyLWU1YTctNGIzMi04NGVhLWExNzc0NTMxZjFkMiIsInR5cCI6IklEIiwiYXpwIjoiYWRtaW4tY2xpIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNGM2YTU4ZjAtMmEwNy00ZTM2LWEzNmYtYjM3YTNmZWY3ZTYyIiwiYWNyIjoiMSIsInRlbmFudHMiOlt7Im5hbWUiOiJFS1oiLCJncm91cHMiOlt7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOlsiZGF0YS1hZG1pbiJdLCJuYW1lIjoiQWRtaW4iLCJpc19zZXJ2aWNlcGF0aCI6ZmFsc2UsImNsaWVudFJvbGVzIjpbInVtYV9wcm90ZWN0aW9uIiwiZW5kcG9pbnQ6Y3JlYXRlIiwiZGV2aWNlOmRhdGEiLCJ1c2VyOmRlbGV0ZSIsInN1YnNjcmlwdGlvbjpyZWFkIiwiZW5kcG9pbnQ6cmVhZCIsImRldmljZTpjcmVhdGUiLCJkZXZpY2Vncm91cDp3cml0ZSIsImdyb3VwOmRlbGV0ZSIsInJlZ2lzdHJhdGlvbjp3cml0ZSIsImVudGl0eTpjcmVhdGUiLCJkZXZpY2Vncm91cDpyZWFkIiwiYWxhcm06ZGVsZXRlIiwicmVnaXN0cmF0aW9uOnJlYWQiLCJyZWdpc3RyYXRpb246ZGVsZXRlIiwiZW50aXR5OndyaXRlIiwiYWxhcm06Y3JlYXRlIiwidXNlcjp3cml0ZSIsInN1YnNjcmlwdGlvbjpkZWxldGUiLCJkZXZpY2U6ZGVsZXRlIiwiZGV2aWNlOndyaXRlIiwiZW50aXR5OmRlbGV0ZSIsImdyb3VwOmNyZWF0ZSIsImRldmljZTpyZWFkIiwiYWxhcm06d3JpdGUiLCJncm91cDp3cml0ZSIsInJlZ2lzdHJhdGlvbjpjcmVhdGUiLCJzdWJzY3JpcHRpb246d3JpdGUiLCJlbnRpdHl0eXBlOnJlYWQiLCJncm91cDpyZWFkIiwic3Vic2NyaXB0aW9uOmNyZWF0ZSIsImVudGl0eTpvcCIsImRldmljZWdyb3VwOmNyZWF0ZSIsImVuZHBvaW50OmRlbGV0ZSIsInVzZXI6cmVhZCIsImVuZHBvaW50OndyaXRlIiwiZW50aXR5OnJlYWQiLCJ1c2VyOmNyZWF0ZSIsImRldmljZWdyb3VwOmRlbGV0ZSIsImFsYXJtOnJlYWQiXX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIl0sIm5hbWUiOiJEZXZlbG9wZXIiLCJpc19zZXJ2aWNlcGF0aCI6ZmFsc2UsImNsaWVudFJvbGVzIjpbImVudGl0eTpkZWxldGUiLCJkZXZpY2U6cmVhZCIsImRldmljZTpkYXRhIiwic3Vic2NyaXB0aW9uOndyaXRlIiwiZW50aXR5dHlwZTpyZWFkIiwic3Vic2NyaXB0aW9uOnJlYWQiLCJlbmRwb2ludDpyZWFkIiwic3Vic2NyaXB0aW9uOmNyZWF0ZSIsImRldmljZTpjcmVhdGUiLCJlbnRpdHk6b3AiLCJkZXZpY2Vncm91cDpjcmVhdGUiLCJkZXZpY2Vncm91cDp3cml0ZSIsInJlZ2lzdHJhdGlvbjp3cml0ZSIsImVuZHBvaW50OndyaXRlIiwiZW50aXR5OnJlYWQiLCJlbnRpdHk6Y3JlYXRlIiwiZGV2aWNlZ3JvdXA6cmVhZCIsInJlZ2lzdHJhdGlvbjpyZWFkIiwiZW50aXR5OndyaXRlIiwiYWxhcm06cmVhZCIsInN1YnNjcmlwdGlvbjpkZWxldGUiLCJkZXZpY2U6d3JpdGUiXX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkVudmlyb25tZW50TWFuYWdlbWVudCIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiRW52aXJvbm1lbnRNYW5hZ2VtZW50L0Flcm9xdWFsIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJFbnZpcm9ubWVudE1hbmFnZW1lbnQvQ2VzdmEiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkVudmlyb25tZW50TWFuYWdlbWVudC9EYXRha29ydW0iLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkVudmlyb25tZW50TWFuYWdlbWVudC9EZWNlbnRsYWIiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkVudmlyb25tZW50TWFuYWdlbWVudC9EZW1vIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJFbnZpcm9ubWVudE1hbmFnZW1lbnQvSGF3YURhd2EiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkVudmlyb25tZW50TWFuYWdlbWVudC9LZWFjb3VzdGljcyIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiRW52aXJvbm1lbnRNYW5hZ2VtZW50L09wZW5XZWF0aGVyIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJFbnZpcm9ubWVudE1hbmFnZW1lbnQvU21hcnRTZW5zZSIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiRW52aXJvbm1lbnRNYW5hZ2VtZW50L1dBUUkiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IkluZnJhc3RydWN0dXJlTWFuYWdlbWVudCIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiSW5mcmFzdHJ1Y3R1cmVNYW5hZ2VtZW50L0RlY2VudGxhYiIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiTW9iaWxpdHlNYW5hZ2VtZW50IiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJQYXJraW5nTWFuYWdlbWVudCIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiUGFya2luZ01hbmFnZW1lbnQvQ2l0aWxvZyIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiUGFya2luZ01hbmFnZW1lbnQvQ2xldmVyY2l0aSIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiUGFya2luZ01hbmFnZW1lbnQvRGF0YWtvcnVtIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJQYXJraW5nTWFuYWdlbWVudC9EZW1vIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJQYXJraW5nTWFuYWdlbWVudC9FS1oiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IlBhcmtpbmdNYW5hZ2VtZW50L05lZGFwIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJQYXJraW5nTWFuYWdlbWVudC9PcGVuQ2hhcmdlTWFwIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJQYXJraW5nTWFuYWdlbWVudC9QbmkiLCJpc19zZXJ2aWNlcGF0aCI6dHJ1ZX0seyJwYXJlbnQiOiJFS1oiLCJyZWFsbVJvbGVzIjpbXSwibmFtZSI6IlBvd2VyTWFuYWdlbWVudCIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiUG93ZXJNYW5hZ2VtZW50L0RhdGFrb3J1bSIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiUG93ZXJNYW5hZ2VtZW50L0VzYXZlIiwiaXNfc2VydmljZXBhdGgiOnRydWV9LHsicGFyZW50IjoiRUtaIiwicmVhbG1Sb2xlcyI6W10sIm5hbWUiOiJUcmFmZmljTWFuYWdlbWVudCIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiVHJhZmZpY01hbmFnZW1lbnQvQ2l0aWxvZyIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiVHJhZmZpY01hbmFnZW1lbnQvRGVtbyIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiVHJhZmZpY01hbmFnZW1lbnQvSEVSRSIsImlzX3NlcnZpY2VwYXRoIjp0cnVlfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiVXNlciIsImlzX3NlcnZpY2VwYXRoIjpmYWxzZSwiY2xpZW50Um9sZXMiOlsidXNlcjpyZWFkIiwidW1hX3Byb3RlY3Rpb24iLCJlbnRpdHk6cmVhZCIsImVudGl0eXR5cGU6cmVhZCJdfSx7InBhcmVudCI6IkVLWiIsInJlYWxtUm9sZXMiOltdLCJuYW1lIjoiV2FzdGVNYW5hZ2VtZW50IiwiaXNfc2VydmljZXBhdGgiOnRydWV9XSwiaWQiOiI3Y2U5YWUyYS1iODBiLTRkNjctYjdhYi1lZmMwMmY4NTE4M2YifV0sImZpd2FyZS1zZXJ2aWNlcyI6eyJFS1oiOlsiL1BhcmtpbmdNYW5hZ2VtZW50IiwiL1BhcmtpbmdNYW5hZ2VtZW50L1BuaSIsIi9Qb3dlck1hbmFnZW1lbnQvRXNhdmUiLCIvTW9iaWxpdHlNYW5hZ2VtZW50IiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9PcGVuV2VhdGhlciIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvU21hcnRTZW5zZSIsIi9UcmFmZmljTWFuYWdlbWVudC9EZW1vIiwiL1Bvd2VyTWFuYWdlbWVudCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvRGVtbyIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvS2VhY291c3RpY3MiLCIvUGFya2luZ01hbmFnZW1lbnQvRGVtbyIsIi9Qb3dlck1hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9EZWNlbnRsYWIiLCIvUGFya2luZ01hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9BZXJvcXVhbCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvRGF0YWtvcnVtIiwiL1BhcmtpbmdNYW5hZ2VtZW50L05lZGFwIiwiL1BhcmtpbmdNYW5hZ2VtZW50L0NpdGlsb2ciLCIvUGFya2luZ01hbmFnZW1lbnQvT3BlbkNoYXJnZU1hcCIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQvV0FRSSIsIi9JbmZyYXN0cnVjdHVyZU1hbmFnZW1lbnQiLCIvUGFya2luZ01hbmFnZW1lbnQvQ2xldmVyY2l0aSIsIi9XYXN0ZU1hbmFnZW1lbnQiLCIvSW5mcmFzdHJ1Y3R1cmVNYW5hZ2VtZW50L0RlY2VudGxhYiIsIi9UcmFmZmljTWFuYWdlbWVudC9DaXRpbG9nIiwiL1RyYWZmaWNNYW5hZ2VtZW50IiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9DZXN2YSIsIi9UcmFmZmljTWFuYWdlbWVudC9IRVJFIiwiL0Vudmlyb25tZW50TWFuYWdlbWVudC9IYXdhRGF3YSIsIi9FbnZpcm9ubWVudE1hbmFnZW1lbnQiLCIvUGFya2luZ01hbmFnZW1lbnQvRUtaIl19LCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IkdhYnJpZWxlIENlcmZvZ2xpbyIsInRlbmFudF9yb2xlcyI6W3sicm9sZXMiOlsidW1hX3Byb3RlY3Rpb24iLCJlbmRwb2ludDpjcmVhdGUiLCJkZXZpY2U6ZGF0YSIsInVzZXI6ZGVsZXRlIiwic3Vic2NyaXB0aW9uOnJlYWQiLCJlbmRwb2ludDpyZWFkIiwiZGV2aWNlOmNyZWF0ZSIsImRldmljZWdyb3VwOndyaXRlIiwiZ3JvdXA6ZGVsZXRlIiwicmVnaXN0cmF0aW9uOndyaXRlIiwiZW50aXR5OmNyZWF0ZSIsImRldmljZWdyb3VwOnJlYWQiLCJhbGFybTpkZWxldGUiLCJyZWdpc3RyYXRpb246cmVhZCIsInJlZ2lzdHJhdGlvbjpkZWxldGUiLCJlbnRpdHk6d3JpdGUiLCJhbGFybTpjcmVhdGUiLCJ1c2VyOndyaXRlIiwic3Vic2NyaXB0aW9uOmRlbGV0ZSIsImRldmljZTpkZWxldGUiLCJkZXZpY2U6d3JpdGUiLCJlbnRpdHk6ZGVsZXRlIiwiZ3JvdXA6Y3JlYXRlIiwiZGV2aWNlOnJlYWQiLCJhbGFybTp3cml0ZSIsImdyb3VwOndyaXRlIiwicmVnaXN0cmF0aW9uOmNyZWF0ZSIsInN1YnNjcmlwdGlvbjp3cml0ZSIsImVudGl0eXR5cGU6cmVhZCIsImdyb3VwOnJlYWQiLCJzdWJzY3JpcHRpb246Y3JlYXRlIiwiZW50aXR5Om9wIiwiZGV2aWNlZ3JvdXA6Y3JlYXRlIiwiZW5kcG9pbnQ6ZGVsZXRlIiwidXNlcjpyZWFkIiwiZW5kcG9pbnQ6d3JpdGUiLCJlbnRpdHk6cmVhZCIsInVzZXI6Y3JlYXRlIiwiZGV2aWNlZ3JvdXA6ZGVsZXRlIiwiYWxhcm06cmVhZCIsImVudGl0eTpkZWxldGUiLCJkZXZpY2U6cmVhZCIsImRldmljZTpkYXRhIiwic3Vic2NyaXB0aW9uOndyaXRlIiwiZW50aXR5dHlwZTpyZWFkIiwic3Vic2NyaXB0aW9uOnJlYWQiLCJlbmRwb2ludDpyZWFkIiwic3Vic2NyaXB0aW9uOmNyZWF0ZSIsImRldmljZTpjcmVhdGUiLCJlbnRpdHk6b3AiLCJkZXZpY2Vncm91cDpjcmVhdGUiLCJkZXZpY2Vncm91cDp3cml0ZSIsInJlZ2lzdHJhdGlvbjp3cml0ZSIsImVuZHBvaW50OndyaXRlIiwiZW50aXR5OnJlYWQiLCJlbnRpdHk6Y3JlYXRlIiwiZGV2aWNlZ3JvdXA6cmVhZCIsInJlZ2lzdHJhdGlvbjpyZWFkIiwiZW50aXR5OndyaXRlIiwiYWxhcm06cmVhZCIsInN1YnNjcmlwdGlvbjpkZWxldGUiLCJkZXZpY2U6d3JpdGUiLCJ1c2VyOnJlYWQiLCJ1bWFfcHJvdGVjdGlvbiIsImVudGl0eTpyZWFkIiwiZW50aXR5dHlwZTpyZWFkIl0sIm5hbWUiOiJFS1oiLCJncm91cHMiOltdLCJpZCI6IjdjZTlhZTJhLWI4MGItNGQ2Ny1iN2FiLWVmYzAyZjg1MTgzZiJ9XSwicHJlZmVycmVkX3VzZXJuYW1lIjoiZ2FicmllbGUuY2VyZm9nbGlvQG1hcnRlbC1pbm5vdmF0ZS5jb20iLCJsb2NhbGUiOiJlbiIsImdpdmVuX25hbWUiOiJHYWJyaWVsZSIsImZhbWlseV9uYW1lIjoiQ2VyZm9nbGlvIiwiZW1haWwiOiJnYWJyaWVsZS5jZXJmb2dsaW9AbWFydGVsLWlubm92YXRlLmNvbSJ9.DN5jsSVJcaE2VLNEAurSlUsD2VnIMc2badLt2FWhxjS9sRUHDQgZ3sG0DWsrFsMmjpXlq7J-oV46eFgdVPHUqR0vLIyyB0CN-IwsHh-syIk0XLy5SBM57QmgzW9XK3JsYuDRLL5RcfsLRKARN47uxgdteoB5c3vjEiHtQ9OPFIVypexI5WYmDTIbXGRG15tNpszm55R2HLZDr74yCQdTcI26XoFt_cyrO7q0C8GyrFzRLPUk5tgSRaaDFgKTC6sdS9h5bz4KDJm__b4goc_A0-lW_NhJY-nfCLl99bYLOZViY3MX94eK4H1wTPx3RkKlhW0dUen6Vl251tRKA7my0g"


echo "\n\ncan i read entities?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities


echo "\n\ncan i create an entity /Path1/Path2  EKZ?"
curl -i --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: EKZ' \
--header 'fiware-ServicePath: /Path1/Path2' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "address": {
    "type": "PostalAddress",
    "value": {
      "addressCountry": "CH",
      "addressLocality": "Dietikon",
      "streetAddress": "Ueberlandstrasse"
    },
    "metadata": {}
  },
  "airQualityIndex": {
    "type": "Number",
    "value": 65,
    "metadata": {}
  },
  "CO": {
    "type": "Number",
    "value": 500,
    "metadata": {}
  },
  "dataProvider": {
    "type": "Text",
    "value": "http://demo",
    "metadata": {}
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2019-06-95T11:00:00",
    "metadata": {}
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        8.4089862,
        47.4082054
      ]
    },
    "metadata": {}
  },
  "NO": {
    "type": "Number",
    "value": 45,
    "metadata": {}
  },
  "NO2": {
    "type": "Number",
    "value": 69,
    "metadata": {}
  },
  "O3": {
    "type": "Number",
    "value": 139,
    "metadata": {}
  },
  "PM1": {
    "type": "Number",
    "value": 10,
    "metadata": {}
  },
  "PM2_5": {
    "type": "Number",
    "value": 4,
    "metadata": {}
  },
  "PM10": {
    "type": "Number",
    "value": 3,
    "metadata": {}
  },
  "pressure": {
    "type": "Number",
    "value": 0.54,
    "metadata": {}
  },
  "refDevice": {
    "type": "Relationship",
    "value": "urn:ngsi-ld:AirQualityObserved:Device:demo",
    "metadata": {}
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 0.68,
    "metadata": {}
  },
  "reliability": {
    "type": "Number",
    "value": 0.7,
    "metadata": {}
  },
  "SO2": {
    "type": "Number",
    "value": 11,
    "metadata": {}
  },
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'

echo "\n\ncan i create an entity /Path1  EKZ?"
curl -i --request POST 'http://localhost:8000/v2/entities' \
--header 'Content: application/json' \
--header 'fiware-Service: EKZ' \
--header 'fiware-ServicePath: /Path1' \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $token" \
--data-raw '{
  "id": "urn:ngsi-ld:AirQualityObserved:demo",
  "type": "AirQualityObserved",
  "address": {
    "type": "PostalAddress",
    "value": {
      "addressCountry": "CH",
      "addressLocality": "Dietikon",
      "streetAddress": "Ueberlandstrasse"
    },
    "metadata": {}
  },
  "airQualityIndex": {
    "type": "Number",
    "value": 65,
    "metadata": {}
  },
  "CO": {
    "type": "Number",
    "value": 500,
    "metadata": {}
  },
  "dataProvider": {
    "type": "Text",
    "value": "http://demo",
    "metadata": {}
  },
  "dateObserved": {
    "type": "DateTime",
    "value": "2019-06-95T11:00:00",
    "metadata": {}
  },
  "location": {
    "type": "geo:json",
    "value": {
      "type": "Point",
      "coordinates": [
        8.4089862,
        47.4082054
      ]
    },
    "metadata": {}
  },
  "NO": {
    "type": "Number",
    "value": 45,
    "metadata": {}
  },
  "NO2": {
    "type": "Number",
    "value": 69,
    "metadata": {}
  },
  "O3": {
    "type": "Number",
    "value": 139,
    "metadata": {}
  },
  "PM1": {
    "type": "Number",
    "value": 10,
    "metadata": {}
  },
  "PM2_5": {
    "type": "Number",
    "value": 4,
    "metadata": {}
  },
  "PM10": {
    "type": "Number",
    "value": 3,
    "metadata": {}
  },
  "pressure": {
    "type": "Number",
    "value": 0.54,
    "metadata": {}
  },
  "refDevice": {
    "type": "Relationship",
    "value": "urn:ngsi-ld:AirQualityObserved:Device:demo",
    "metadata": {}
  },
  "relativeHumidity": {
    "type": "Number",
    "value": 0.68,
    "metadata": {}
  },
  "reliability": {
    "type": "Number",
    "value": 0.7,
    "metadata": {}
  },
  "SO2": {
    "type": "Number",
    "value": 11,
    "metadata": {}
  },
  "temperature": {
    "type": "Number",
    "value": 12.2,
    "metadata": {}
  }
}'

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo attributes?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs

echo "\n\ncan i read entity urn:ngsi-ld:AirQualityObserved:demo temperature?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/urn:ngsi-ld:AirQualityObserved:demo/attrs/temperature

echo "\n\ncan i read entity ent2?"
curl -i -H "Authorization: Bearer $token" -H "fiware-service: EKZ" -H "fiware-servicepath: /Path1/Path2" http://localhost:8000/v2/entities/ent2
