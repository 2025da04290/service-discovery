FROM eclipse-temurin:21-jre-alpine

LABEL maintainer="vk"
LABEL service="service-discovery"

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY build/libs/service-discovery.jar app.jar

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8761

ENV JAVA_OPTS="-Xms256m -Xmx512m"

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8761/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
