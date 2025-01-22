#FROM golang:1.21 as base
# as from the project https://github.com/iam-veeramalla/go-web-app.git
# under go.mod file the go should be 1.22.5
FROM golang:1.22.5 as base
WORKDIR /app
# Dependencies for a go application are stored in the go.mod 
# we can use RUN go mod download 
# check if any dependencies are there in the go.mod file
COPY go.mod . 
RUN go mod download
COPY . .
# binary called main is created on the docker image 
RUN go build -o main .

# Final stage with distrosless image
FROM gcr.io/distroless/base
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD [ "./main" ]