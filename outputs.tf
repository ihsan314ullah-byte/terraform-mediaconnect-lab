output "flow_arn" {
  value = awscc_mediaconnect_flow.srt_listener.flow_arn
}

output "flow_name" {
  value = awscc_mediaconnect_flow.srt_listener.name
}

output "source_ingest_ip" {
  value = awscc_mediaconnect_flow.srt_listener.source.ingest_ip
}

output "source_ingest_port" {
  value = awscc_mediaconnect_flow.srt_listener.source.ingest_port
}

output "medialive_input_id" {
  value = aws_medialive_input.mediaconnect_input.id
}

output "medialive_channel_id" {
  value = aws_medialive_channel.channel.id
}

output "mediapackage_channel_id" {
  value = aws_media_package_channel.mp_v1_channel.id
}

output "hls_endpoint_url" {
  value = aws_cloudformation_stack.mp_v1_hls_endpoint.outputs["HlsEndpointUrl"]
}

output "dash_endpoint_url" {
  value = aws_cloudformation_stack.mp_v1_dash_endpoint.outputs["DashEndpointUrl"]
}