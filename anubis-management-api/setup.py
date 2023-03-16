"""A setuptools based setup module.
See:
https://packaging.python.org/guides/distributing-packages-using-setuptools/
https://github.com/pypa/sampleproject
Modified by Madoshakalaka@Github (dependency links added)
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages
from os import path
from anubis.version import ANUBIS_VERSION

long_description = """
This package contains the Anubis Policy Management API. For more information,
visit the [Github Page](https://github.com/orchestracities/anubis).
"""

# Arguments marked as "Required" below must be included for upload to PyPI.
# Fields marked as "Optional" may be commented out.

setup(
    name="anubis-policy-api",  # Required
    version=ANUBIS_VERSION,  # Required
    description="The main module of anubis",  # Optional
    long_description=long_description,  # Optional
    long_description_content_type="text/markdown",  # Optional
    url="https://github.com/orchestracities/anubis",  # Optional
    author="Martel-Innovate",  # Optional
    author_email="gabriele.cerfoglio@martel-innovate.com",  # Optional
    classifiers=[  # Optional
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries :: Python Modules",
        # "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.9",
    ],
    # keywords="policy management library",  # Optional
    packages=find_packages(exclude=["contrib", "docs", "tests"]),  # Required
    python_requires=">=3.7",
    install_requires=[
        'aiosqlite==0.17.0',
        "anyio==3.5.0; python_full_version >= '3.6.2'",
        "asgiref==3.5.1; python_version >= '3.7'",
        'asn1crypto==1.5.1',
        'certifi==2022.12.7',
        "charset-normalizer==2.0.12; python_version >= '3'",
        "click==8.1.3; python_version >= '3.7'",
        'databases==0.6.0',
        'fastapi==0.78.0',
        "greenlet==1.1.2; python_version >= '3' and platform_machine == 'aarch64' or (platform_machine == 'ppc64le' or (platform_machine == 'x86_64' or (platform_machine == 'amd64' or (platform_machine == 'AMD64' or (platform_machine == 'win32' or platform_machine == 'WIN32')))))",
        "h11==0.13.0; python_version >= '3.6'",
        "idna==3.3; python_version >= '3.5'",
        'isodate==0.6.1',
        'opa-python-client==1.3.3',
        'pg8000==1.29.1',
        'pydantic==1.9.0',
        'pyjwt==2.4.0',
        "pyparsing==3.0.8; python_full_version >= '3.6.8'",
        'pyyaml==6.0',
        'rdflib==6.1.1',
        "requests==2.28.1; python_version >= '2.7' and python_version not in '3.0, 3.1, 3.2, 3.3, 3.4, 3.5'",
        'rfc3987==1.3.8',
        "scramp==1.4.1; python_version >= '3.6'",
        "setuptools==62.1.0; python_version >= '3.7'",
        "six==1.16.0; python_version >= '2.7' and python_version not in '3.0, 3.1, 3.2, 3.3'",
        "sniffio==1.2.0; python_version >= '3.5'",
        'sqlalchemy==1.4.36',
        "starlette==0.19.1; python_version >= '3.6'",
        "typing-extensions==4.2.0; python_version >= '3.7'",
        'urllib3==1.26.9',
        'user-agent==0.1.10',
        'uuid==1.30',
        'uvicorn==0.18.1'],
    # Optional
    extras_require={"dev": []},  # Optional
    dependency_links=[],
    project_urls={  # Optional
        "Bug Reports": "https://github.com/orchestracities/anubis/issues",
        "Source": "https://github.com/orchestracities/anubis",
    },
)
