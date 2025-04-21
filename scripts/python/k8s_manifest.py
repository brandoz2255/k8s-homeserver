import yaml
import os

# Thhis was the simple test script to see what I wanted to do before adding gen k8s
def generate_k8s_manifest(app_name, docker_image, container_port=80, output_dir="."):
    deployment = {
        "apiVersion": "apps/v1",
        "kind": "Deployment",
        "metadata": {"name": app_name, "labels": {"app": app_name}},
        "spec": {
            "replicas": 1,
            "selector": {"matchLabels": {"app": app_name}},
            "template": {
                "metadata": {"labels": {"app": app_name}},
                "spec": {
                    "containers": [
                        {
                            "name": app_name,
                            "image": docker_image,
                            "ports": [{"containerPort": container_port}],
                        }
                    ]
                },
            },
        },
    }

    service = {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {"name": f"{app_name}-service"},
        "spec": {
            "selector": {"app": app_name},
            "ports": [{"protocol": "TCP", "port": 80, "targetPort": container_port}],
            "type": "ClusterIP",
        },
    }

    manifest = [deployment, service]

    output_path = os.path.join(output_dir, f"{app_name}-k8s.yaml")
    with open(output_path, "w") as f:
        yaml.dump_all(manifest, f, sort_keys=False)

    print(f"✅ Kubernetes manifest written to: {output_path}")


# Example usage
if __name__ == "__main__":
    app_name = input("📝 Enter app name: ")
    docker_image = input("🐳 Enter Docker image: ")
    port_input = input("📦 Enter container port (default 80): ")

    try:
        container_port = int(port_input) if port_input else 80
    except ValueError:
        print("⚠️ Invalid port. Using default 80.")
        container_port = 80

    generate_k8s_manifest(app_name, docker_image, container_port)
