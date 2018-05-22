# test

# Build cache for Dockerfiles

Build cache
During the process of building an image Docker steps through the instructions in your Dockerfile executing each in the order specified. As each instruction is examined Docker looks for an existing image in its cache that it can reuse, rather than creating a new (duplicate) image. If you do not want to use the cache at all you can use the --no-cache=true option on the docker build command.

However, if you do let Docker use its cache then it is very important to understand when it can, and cannot, find a matching image. The basic rules that Docker follows are outlined below:

Starting with a parent image that is already in the cache, the next instruction is compared against all child images derived from that base image to see if one of them was built using the exact same instruction. If not, the cache is invalidated.

In most cases simply comparing the instruction in the Dockerfile with one of the child images is sufficient. However, certain instructions require a little more examination and explanation.

For the ADD and COPY instructions, the contents of the file(s) in the image are examined and a checksum is calculated for each file. The last-modified and last-accessed times of the file(s) are not considered in these checksums. During the cache lookup, the checksum is compared against the checksum in the existing images. If anything has changed in the file(s), such as the contents and metadata, then the cache is invalidated.

Aside from the ADD and COPY commands, cache checking does not look at the files in the container to determine a cache match. For example, when processing a RUN apt-get -y update command the files updated in the container are not examined to determine if a cache hit exists. In that case just the command string itself is used to find a match.

Once the cache is invalidated, all subsequent Dockerfile commands generate new images and the cache is not used.
