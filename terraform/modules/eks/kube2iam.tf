# @read https://gist.github.com/snoby/77a49b6b79d0dd2ad9afbbf533588f54#setup-kube2iam-in-your-cluster
data "template_file" "kube2iam" {
  template = file("${path.module}/templates/kube2iam.yaml.tpl")
  vars = {
    account_id       = data.aws_caller_identity.current.account_id
    kube2iam_version = var.kube2iam_version
    worker_role      = aws_iam_role.eks_worker_role.arn
  }
}

resource "local_file" "kube2iam" {
  count      = var.render_files ? 1 : 0
  content    = data.template_file.kube2iam.rendered
  filename   = "dist/1.kube2iam_${aws_eks_cluster.k8s.name}.yaml"
  depends_on = [null_resource.clean_dist]
}

