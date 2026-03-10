resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "9.4.10"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
}

resource "kubernetes_manifest" "appset" {
  depends_on = [helm_release.argocd]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"
    metadata = {
      name      = "apps"
      namespace = "argocd"
    }
    spec = {
      goTemplate        = true
      goTemplateOptions = ["missingkey=error"]
      generators = [{
        git = {
          repoURL  = "https://github.com/m1xxos/selectel-ai.git"
          revision = "HEAD"
          directories = [{
            path = "argo/*"
          }]
        }
      }]
      template = {
        metadata = {
          name = "{{ .path.basename }}"
        }
        spec = {
          project = "default"
          source = {
            repoURL        = "https://github.com/m1xxos/selectel-ai.git"
            targetRevision = "HEAD"
            path           = "{{ .path.path }}"
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = "{{ .path.basename }}"
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
            syncOptions = [
              "CreateNamespace=true"
            ]
          }
        }
      }
    }
  }
}
