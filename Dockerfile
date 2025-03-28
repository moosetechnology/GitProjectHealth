# Use the official smalltalkci image from Docker Hub
FROM hpiswa/smalltalkci

# Set environment variables
ENV ORIGIN_IMAGE_NAME=Moose64-11
ENV IMAGE_NAME=PharoServer

# Set the working directory
WORKDIR /usr/src/app

# Copy your Smalltalk project files into the container
COPY . .

# Run the CI script commands
RUN smalltalkci -s "${ORIGIN_IMAGE_NAME}" .smalltalk.ston
RUN mkdir ${IMAGE_NAME}
RUN mv /root/smalltalkCI-master/_builds/* ./${IMAGE_NAME}
RUN mv ./${IMAGE_NAME}/*/* ./${IMAGE_NAME}
RUN mv ${IMAGE_NAME}/TravisCI.changes ${IMAGE_NAME}/${IMAGE_NAME}.changes
RUN mv ${IMAGE_NAME}/TravisCI.image ${IMAGE_NAME}/${IMAGE_NAME}.image
RUN rm ${IMAGE_NAME}/build_status.txt
RUN rm -rf ${IMAGE_NAME}/vm

# Expose any ports the application might need (if applicable)
# EXPOSE 8080

# Set the command to run your Smalltalk application
CMD ["/root/smalltalkCI-master/_cache/vms/Moose64-11/pharo", "--headless", "PharoServer/PharoServer.image", "st", "./docs/launchAnalyze.st"]
# the output csv files will be under /root/*.csv
