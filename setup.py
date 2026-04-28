from setuptools import setup

with open("README.rst", "r") as fh:
    long_description = fh.read()

setup(
    name="xontrib-envrc",
    version="2.0.0",
    license="MIT",
    url="https://github.com/arkhan/xontrib-envrc",
    description="direnv (.envrc) support for the xonsh shell",
    long_description=long_description,
    long_description_content_type="text/x-rst",
    author="74th",
    author_email="site@74th.tech",
    packages=["xontrib"],
    package_dir={"xontrib": "xontrib"},
    package_data={"xontrib": ["*.xsh"]},
    zip_safe=False,
    python_requires=">=3.10",
    install_requires=[
        "xonsh>=0.19.0",
    ],
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Environment :: Console",
        "Environment :: Plugins",
        "Intended Audience :: End Users/Desktop",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3 :: Only",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
    ],
)
