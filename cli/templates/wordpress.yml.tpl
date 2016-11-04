apiVersion: v1
kind: Service
metadata:
  name: %STACK_NAME%
  labels:
    app: wordpress
spec:
  ports:
    - port: 80
  selector:
    app: wordpress
  clusterIP: None
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: %STACK_NAME%
  labels:
    app: wordpress
spec:
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
      - image: kopachevsky/wordpress
        name: wordpress
        env:
        - name: WORDPRESS_DB_HOST
          value: ai-mysql
        - name: WORDPRESS_DB_NAME
          value: "wordpress"
        - name: WORDPRESS_DB_USER
          value: "wordpress"
        - name: WORDPRESS_DB_PASSWORD
          value: "password"
        ports:
        - containerPort: 80
          name: wordpress
        volumeMounts:
        - name: wordpress-persistent-storage
          mountPath: /var/www/html/blog
      volumes:
      - name: wordpress-persistent-storage
        awsElasticBlockStore:
          volumeID: %VOLUME_ID_WP%
          fsType: ext4
